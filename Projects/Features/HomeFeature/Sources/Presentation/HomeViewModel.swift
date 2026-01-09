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

    struct Input {
        let saveTokenTapped: Observable<Void>
        let fetchMoviesTapped: Observable<Void>
        let movieDetailTapped: Observable<Int>
    }

    struct Output {
        let resultText: Driver<String>
        let isLoading: Driver<Bool>
        let isMoviesFetched: Driver<Bool>
    }

    private let useCase: HomeUseCase
    private let keyStore: APIKeyStore
    private let disposeBag = DisposeBag()
    public let routeToMovieDetail = PublishSubject<Int>()
    
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
        let isMoviesFetchedRelay = BehaviorRelay<Bool>(value: false)
        let resultTextRelay = BehaviorRelay<String>(
            value: "Press 'Save API Token' first, then fetch movies"
        )

        input.saveTokenTapped
            .subscribe(onNext: { [weak self] in
                self?.saveToken(to: resultTextRelay)
            })
            .disposed(by: disposeBag)

        input.fetchMoviesTapped
            .do(onNext: {
                resultTextRelay.accept("Loading...")
                isLoadingRelay.accept(true)
            })
            .flatMapLatest { [weak self] () -> Single<PaginatedEntity<NowPlayingMoviesEntity>> in
                guard let self else { return .never() }

                nonisolated(unsafe) let useCase = self.useCase
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
                onNext: { paginatedEntity in
                    let movieCount = paginatedEntity.results.count
                    let firstMovie = paginatedEntity.results.first

                    var resultText = "✅ Success!\n\n"
                    resultText += "Total Results: \(paginatedEntity.totalResults)\n"
                    resultText += "Total Pages: \(paginatedEntity.totalPages)\n"
                    resultText += "Current Page: \(paginatedEntity.page)\n"
                    resultText += "Movies Loaded: \(movieCount)\n\n"

                    if let movie = firstMovie {
                        resultText += "First Movie:\n"
                        resultText += "Title: \(movie.title)\n"
                        resultText += "Release: \(movie.releaseDate ?? "N/A")"
                    }

                    resultTextRelay.accept(resultText)
                    isMoviesFetchedRelay.accept(true)
                },
                onError: { error in
                    resultTextRelay.accept("❌ Error:\n\(error.localizedDescription)")
                    isMoviesFetchedRelay.accept(false)
                }
            )
            .disposed(by: disposeBag)

        input.movieDetailTapped
            .subscribe(onNext: { [weak self] movieID in
                self?.routeToMovieDetail.onNext(movieID)
            })
            .disposed(by: disposeBag)

        return Output(
            resultText: resultTextRelay.asDriver(),
            isLoading: isLoadingRelay.asDriver(),
            isMoviesFetched: isMoviesFetchedRelay.asDriver()
        )
    }

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
    
    public func didSelectMovie(id: Int) {
        routeToMovieDetail.onNext(id)
    }
}
