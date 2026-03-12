//
//  MovieDetailViewModel.swift
//  MovieFeature
//
//  Created by 박서연 on 1/23/26.
//  Copyright © 2026 linda. All rights reserved.
//

import CoreModels
import CorePersistence

import RxSwift
import RxRelay
import RxCocoa

@MainActor
public final class MovieDetailViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
        let youtubeButtonTapped: Observable<Void>
        let favoriteButtonTapped: Observable<Void>
    }

    struct Output {
        let movieDetail: Driver<MovieDetailBundleEntity>
        let similarMovies: Driver<[SimilarMoviesEntity]>
        let isLoading: Driver<Bool>
        let errorMessage: Signal<String>
        let openYouTubeURL: Signal<String>
        let isFavorite: Driver<Bool>
        let favoriteResult: Signal<Bool> // true: 추가 성공, false: 제거 성공
    }

    private let useCase: MovieDetailUseCase
    private let movieID: Int
    private let disposeBag = DisposeBag()

    private let movieDetailRelay = BehaviorRelay<MovieDetailBundleEntity?>(value: nil)
    private let similarMoviesRelay = BehaviorRelay<[SimilarMoviesEntity]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorMessageRelay = PublishRelay<String>()
    private let openYouTubeRelay = PublishRelay<String>()
    private let isFavoriteRelay = BehaviorRelay<Bool>(value: false)
    private let favoriteResultRelay = PublishRelay<Bool>()
    
    public init(movieID: Int, useCase: MovieDetailUseCase) {
        self.movieID = movieID
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                owner.fetchMovieDetail()
                owner.fetchSimilarMovies(page: 1)
                owner.checkFavoriteStatus()
            }
            .disposed(by: disposeBag)

        input.youtubeButtonTapped
            .withLatestFrom(movieDetailRelay.compactMap { $0 })
            .subscribe(with: self) { owner, movieDetail in
                let trailers = movieDetail.videos.filter { $0.type == "Trailer" }
                if let trailer = trailers.first, let key = trailer.key {
                    owner.openYouTubeRelay.accept(key)
                } else {
                    owner.errorMessageRelay.accept("트레일러를 찾을 수 없습니다")
                }
            }
            .disposed(by: disposeBag)

        input.favoriteButtonTapped
            .withLatestFrom(movieDetailRelay.compactMap { $0 })
            .subscribe(with: self) { owner, movieDetail in
                owner.toggleFavorite(movieDetail: movieDetail)
            }
            .disposed(by: disposeBag)

        return Output(
            movieDetail: movieDetailRelay
                .compactMap { $0 }
                .asDriver(onErrorDriveWith: .empty()),
            similarMovies: similarMoviesRelay.asDriver(),
            isLoading: isLoadingRelay.asDriver(),
            errorMessage: errorMessageRelay.asSignal(),
            openYouTubeURL: openYouTubeRelay.asSignal(),
            isFavorite: isFavoriteRelay.asDriver(),
            favoriteResult: favoriteResultRelay.asSignal()
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
    
    private func fetchSimilarMovies(page: Int) {
        Task { [movieID, useCase] in
            do {
                let response = try await useCase.fetchSimilarMovies(movieId: movieID, page: page)
                similarMoviesRelay.accept(response.results)
            } catch {
                errorMessageRelay.accept(error.localizedDescription)
            }
        }
    }

    private func checkFavoriteStatus() {
        let isFavorite = FavoriteMovieManager.shared.isFavorite(movieID: movieID)
        isFavoriteRelay.accept(isFavorite)
    }

    private func toggleFavorite(movieDetail: MovieDetailBundleEntity) {
        let detail = movieDetail.detail

        do {
            try FavoriteMovieManager.shared.toggleFavorite(
                movieID: movieID,
                title: detail.title,
                posterPath: detail.posterPath,
                movieDescription: detail.overview ?? ""
            )

            // 상태 업데이트
            let newStatus = FavoriteMovieManager.shared.isFavorite(movieID: movieID)
            isFavoriteRelay.accept(newStatus)
            favoriteResultRelay.accept(newStatus)
        } catch {
            errorMessageRelay.accept("즐겨찾기 처리 실패: \(error.localizedDescription)")
        }
    }
}
