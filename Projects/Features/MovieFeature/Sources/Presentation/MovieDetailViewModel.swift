//
//  MovieDetailViewModel.swift
//  MovieFeature
//
//  Created by 박서연 on 1/23/26.
//  Copyright © 2026 linda. All rights reserved.
//

import CoreModels

import RxSwift
import RxRelay
import RxCocoa

@MainActor
public final class MovieDetailViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
    }

    struct Output {
        let movieDetail: Driver<MovieDetailBundleEntity>
        let isLoading: Driver<Bool>
        let errorMessage: Signal<String>
    }

    private let useCase: MovieDetailUseCase
    private let movieID: Int
    private let disposeBag = DisposeBag()

    private let movieDetailRelay = BehaviorRelay<MovieDetailBundleEntity?>(value: nil)
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorMessageRelay = PublishRelay<String>()

    public init(movieID: Int, useCase: MovieDetailUseCase) {
        self.movieID = movieID
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                owner.fetchMovieDetail()
            }
            .disposed(by: disposeBag)

        return Output(
            movieDetail: movieDetailRelay
                .compactMap { $0 }
                .asDriver(onErrorDriveWith: .empty()),
            isLoading: isLoadingRelay.asDriver(),
            errorMessage: errorMessageRelay.asSignal()
        )
    }

    private func fetchMovieDetail() {
        isLoadingRelay.accept(true)

        Task { [movieID, useCase] in
            do {
                let bundle = try await useCase.fetchMovieDetail(movieId: movieID)
                print("✅ BUNDLE: \(bundle)")
                movieDetailRelay.accept(bundle)
            } catch {
                errorMessageRelay.accept(error.localizedDescription)
            }
            isLoadingRelay.accept(false)
        }
    }
}
