//
//  HomeViewModel.swift
//  HomeFeature
//
//  Created by 박서연 on 12/28/25.
//  Copyright © 2025 linda. All rights reserved.
//

import Foundation
import CoreModels
import CoreSecurity

import RxSwift
import RxRelay
import RxCocoa

public final class HomeViewModel {

    // MARK: - Input
    struct Input {
        let saveTokenTapped: Observable<Void>
        let fetchMoviesTapped: Observable<Void>
    }

    // MARK: - Output
    struct Output {
        let resultText: Driver<String>
        let isLoading: Driver<Bool>
    }

    // MARK: - Properties
    private let useCase: HomeUseCase
    private let keyStore: APIKeyStore
    private let disposeBag = DisposeBag()

    // MARK: - Init
    public init(
        useCase: HomeUseCase,
        keyStore: APIKeyStore = KeychainAPIKeyStore()
    ) {
        self.useCase = useCase
        self.keyStore = keyStore
    }

    // MARK: - Transform
    func transform(input: Input) -> Output {
        let isLoadingRelay = BehaviorRelay<Bool>(value: false)
        let resultTextRelay = BehaviorRelay<String>(
            value: "Press 'Save API Token' first, then fetch movies"
        )

        // Save Token
        input.saveTokenTapped
            .subscribe(onNext: { [weak self] in
                self?.saveToken(to: resultTextRelay)
            })
            .disposed(by: disposeBag)

        // Fetch Movies
        input.fetchMoviesTapped
            .do(onNext: {
                resultTextRelay.accept("Loading...")
                isLoadingRelay.accept(true)
            })
            .flatMapLatest { [weak self] () -> Single<NowPlayingEntity> in
                guard let self else { return .never() }
                
                nonisolated(unsafe) let useCase = self.useCase
                
                // ✅ RxSwift의 Swift Concurrency 지원 생성자 사용!
                return Single.create {
                    try await useCase.fetchNowPlayingMovies(page: 1)
                }
            }
            .asObservable()
            .observe(on: MainScheduler.instance)
            .do(
                onNext: { _ in isLoadingRelay.accept(false) },
                onError: { _ in isLoadingRelay.accept(false) }
            )
            .subscribe(
                onNext: { entity in
                    let movieCount = entity.results.count
                    let firstMovie = entity.results.first

                    var resultText = "✅ Success!\n\n"
                    resultText += "Total Results: \(entity.totalResults)\n"
                    resultText += "Total Pages: \(entity.totalPages)\n"
                    resultText += "Current Page: \(entity.page)\n"
                    resultText += "Movies Loaded: \(movieCount)\n\n"

                    if let movie = firstMovie {
                        resultText += "First Movie:\n"
                        resultText += "Title: \(movie.title)\n"
                        resultText += "Release: \(movie.releaseDate)"
                    }

                    resultTextRelay.accept(resultText)
                },
                onError: { error in
                    resultTextRelay.accept("❌ Error:\n\(error.localizedDescription)")
                }
            )
            .disposed(by: disposeBag)

        return Output(
            resultText: resultTextRelay.asDriver(),
            isLoading: isLoadingRelay.asDriver()
        )
    }

    // MARK: - Private Methods
    private func saveToken(to relay: BehaviorRelay<String>) {
        guard let token = Bundle.main.object(
            forInfoDictionaryKey: "TMDB_ACCESS_TOKEN"
        ) as? String else {
            relay.accept("❌ Error: TMDB_ACCESS_TOKEN not found in Info.plist")
            return
        }

        do {
            try keyStore.save(token)
            relay.accept("✅ API Token saved to Keychain successfully!")
        } catch {
            relay.accept("❌ Failed to save token:\n\(error.localizedDescription)")
        }
    }
}
