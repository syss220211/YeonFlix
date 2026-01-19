//
//  HomeViewModel.swift
//  HomeFeature
//
//  Created by 박서연 on 12/28/25.
//  Copyright © 2025 linda. All rights reserved.
//

import Foundation
import CoreModels

import RxSwift
import RxRelay
import RxCocoa

struct HomePosterItem: Hashable {
    let id: Int
    let posterPath: String?
}

@MainActor
final public class HomeViewModel {

    // MARK: - Input / Output
    struct Input {
        let viewDidLoad: Observable<Void>
        let refresh: Observable<Void>
    }

    struct Output {
        let nowPlaying: Driver<[HomePosterItem]>
        let popular: Driver<[HomePosterItem]>
        let topRated: Driver<[HomePosterItem]>
        let upcoming: Driver<[HomePosterItem]>

        let isLoading: Driver<Bool>
        let errorMessage: Signal<String>
    }

    // MARK: - Dependencies
    private let useCase: HomeUseCase

    // MARK: - State
    private let nowPlayingRelay = BehaviorRelay<[HomePosterItem]>(value: [])
    private let popularRelay = BehaviorRelay<[HomePosterItem]>(value: [])
    private let topRatedRelay = BehaviorRelay<[HomePosterItem]>(value: [])
    private let upcomingRelay = BehaviorRelay<[HomePosterItem]>(value: [])

    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorRelay = PublishRelay<String>()

    private let disposeBag = DisposeBag()

    public init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
    
    @MainActor
    func transform(input: Input) -> Output {

        // 최초 진입 + refresh 모두 "첫 페이지 다시 로드"
        let loadTrigger = Observable.merge(input.viewDidLoad, input.refresh)

        loadTrigger
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self else { return .empty() }
                return self.fetchAllFirstPages()
            }
            .subscribe()
            .disposed(by: disposeBag)

        return Output(
            nowPlaying: nowPlayingRelay.asDriver(),
            popular: popularRelay.asDriver(),
            topRated: topRatedRelay.asDriver(),
            upcoming: upcomingRelay.asDriver(),
            isLoading: isLoadingRelay.asDriver(),
            errorMessage: errorRelay.asSignal()
        )
    }

    @MainActor
    private func fetchAllFirstPages() -> Observable<Void> {
        isLoadingRelay.accept(true)

        // 4개를 동시에 요청하고, 다 끝나면 UI 갱신
        let now = fetchNowPlaying(page: 1)
        let pop = fetchPopular(page: 1)
        let top = fetchTopRated(page: 1)
        let upc = fetchUpcoming(page: 1)

        return Single.zip(now, pop, top, upc)
            .do(
                onSuccess: { [weak self] nowItems, popItems, topItems, upcItems in
                    guard let self else { return }
                    self.nowPlayingRelay.accept(nowItems)
                    self.popularRelay.accept(popItems)
                    self.topRatedRelay.accept(topItems)
                    self.upcomingRelay.accept(upcItems)
                },
//                onFailure: { [weak self] error in
//                    self?.errorRelay.accept(error.localizedDescription)
//                },
                onDispose: { [weak self] in
                    self?.isLoadingRelay.accept(false)
                }
            )
            .map { _ in () }
            .asObservable()
    }
    
    @MainActor
    private func fetchNowPlaying(page: Int) -> Single<[HomePosterItem]> {
        Single.create { [useCase] single in
            let task = Task {
                do {
                    let response = try await useCase.fetchNowPlayingMovies(page: page)
                    let items = response.results.map { HomePosterItem(id: $0.id, posterPath: $0.posterPath) }
                    print("✅ Now Playing fetched: \(items.count) items")
                    print("First poster path: \(items.first?.posterPath ?? "nil")")
                    single(.success(items))
                } catch {
                    print("❌ Now Playing error: \(error)")
                    single(.failure(error))
                }
            }
            return Disposables.create { task.cancel() }
        }
    }

    private func fetchPopular(page: Int) -> Single<[HomePosterItem]> {
        Single.create { [useCase] single in
            let task = Task {
                do {
                    let response = try await useCase.fetchPopularMovies(page: page)
                    let items = response.results.map { HomePosterItem(id: $0.id, posterPath: $0.posterPath) }
                    single(.success(items))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create { task.cancel() }
        }
    }

    private func fetchTopRated(page: Int) -> Single<[HomePosterItem]> {
        Single.create { [useCase] single in
            let task = Task {
                do {
                    let response = try await useCase.fetchTopRateMovies(page: page)
                    let items = response.results.map { HomePosterItem(id: $0.id, posterPath: $0.posterPath) }
                    single(.success(items))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create { task.cancel() }
        }
    }

    private func fetchUpcoming(page: Int) -> Single<[HomePosterItem]> {
        Single.create { [useCase] single in
            let task = Task {
                do {
                    let response = try await useCase.fetchUpcomingMovies(page: page)
                    let items = response.results.map { HomePosterItem(id: $0.id, posterPath: $0.posterPath) }
                    single(.success(items))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create { task.cancel() }
        }
    }
}

//public final class HomeViewModel {
//
//    struct Input {
//        let saveTokenTapped: Observable<Void>
//        let fetchMoviesTapped: Observable<Void>
//        let movieDetailTapped: Observable<Int>
//    }
//
//    struct Output {
//        let resultText: Driver<String>
//        let isLoading: Driver<Bool>
//        let isMoviesFetched: Driver<Bool>
//    }
//
//    private let useCase: HomeUseCase
//    private let keyStore: APIKeyStore
//    private let disposeBag = DisposeBag()
//    public let routeToMovieDetail = PublishSubject<Int>()
//    
//    public init(
//        useCase: HomeUseCase,
//        keyStore: APIKeyStore = KeychainAPIKeyStore()
//    ) {
//        self.useCase = useCase
//        self.keyStore = keyStore
//    }
//
//    // MARK: - Transform
//    func transform(input: Input) -> Output {
//        let isLoadingRelay = BehaviorRelay<Bool>(value: false)
//        let isMoviesFetchedRelay = BehaviorRelay<Bool>(value: false)
//        let resultTextRelay = BehaviorRelay<String>(
//            value: "Press 'Save API Token' first, then fetch movies"
//        )
//
//        input.saveTokenTapped
//            .subscribe(onNext: { [weak self] in
//                self?.saveToken(to: resultTextRelay)
//            })
//            .disposed(by: disposeBag)
//
//        input.fetchMoviesTapped
//            .do(onNext: {
//                resultTextRelay.accept("Loading...")
//                isLoadingRelay.accept(true)
//            })
//            .flatMapLatest { [weak self] () -> Single<PaginatedEntity<NowPlayingMoviesEntity>> in
//                guard let self else { return .never() }
//
//                nonisolated(unsafe) let useCase = self.useCase
//                return Single.create {
//                    try await useCase.fetchNowPlayingMovies(page: 1)
//                }
//            }
//            .asObservable()
//            .observe(on: MainScheduler.instance)
//            .do(
//                onNext: { _ in isLoadingRelay.accept(false) },
//                onError: { _ in isLoadingRelay.accept(false) }
//            )
//            .subscribe(
//                onNext: { paginatedEntity in
//                    let movieCount = paginatedEntity.results.count
//                    let firstMovie = paginatedEntity.results.first
//
//                    var resultText = "✅ Success!\n\n"
//                    resultText += "Total Results: \(paginatedEntity.totalResults)\n"
//                    resultText += "Total Pages: \(paginatedEntity.totalPages)\n"
//                    resultText += "Current Page: \(paginatedEntity.page)\n"
//                    resultText += "Movies Loaded: \(movieCount)\n\n"
//
//                    if let movie = firstMovie {
//                        resultText += "First Movie:\n"
//                        resultText += "Title: \(movie.title)\n"
//                        resultText += "Release: \(movie.releaseDate ?? "N/A")"
//                    }
//
//                    resultTextRelay.accept(resultText)
//                    isMoviesFetchedRelay.accept(true)
//                },
//                onError: { error in
//                    resultTextRelay.accept("❌ Error:\n\(error.localizedDescription)")
//                    isMoviesFetchedRelay.accept(false)
//                }
//            )
//            .disposed(by: disposeBag)
//
//        input.movieDetailTapped
//            .subscribe(onNext: { [weak self] movieID in
//                self?.routeToMovieDetail.onNext(movieID)
//            })
//            .disposed(by: disposeBag)
//
//        return Output(
//            resultText: resultTextRelay.asDriver(),
//            isLoading: isLoadingRelay.asDriver(),
//            isMoviesFetched: isMoviesFetchedRelay.asDriver()
//        )
//    }
//
//    private func saveToken(to relay: BehaviorRelay<String>) {
//        guard let token = Bundle.main.object(
//            forInfoDictionaryKey: "TMDB_ACCESS_TOKEN"
//        ) as? String else {
//            relay.accept("❌ Error: TMDB_ACCESS_TOKEN not found in Info.plist")
//            return
//        }
//
//        do {
//            try keyStore.save(token)
//            relay.accept("✅ API Token saved to Keychain successfully!")
//        } catch {
//            relay.accept("❌ Failed to save token:\n\(error.localizedDescription)")
//        }
//    }
//    
//    public func didSelectMovie(id: Int) {
//        routeToMovieDetail.onNext(id)
//    }
//}
