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

    private let useCase: HomeUseCase

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
        // View단의 이벤트 viewDidLoad, refresh 하나의 스트림으로 합침
        let loadTrigger = Observable.merge(input.viewDidLoad, input.refresh)

        loadTrigger
            // loadTrigger가 한 번이라도 발생하면 fetchAllFirstPages 함수 싫행
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self else { return .empty() }
                return self.fetchAllFirstPages()
            }
            .subscribe()
            .disposed(by: disposeBag)

        // VC에게 사용할 상태들을 리턴 (Output)
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

        // 4개가 모두 성공했을 때 한 번에 결과를 묶어줌 (하나라도 실패하면 zip 전체가 실패)
        return Single.zip(now, pop, top, upc)
            .do(
                // zip이 성공한 경우 items들이 생성되며 Relay들에게 .accept으로 값을 넣어줌
                onSuccess: { [weak self] nowItems, popItems, topItems, upcItems in
                    guard let self else { return }
                    // Relay 상태 저장을 하고 변경 이벤트들을 방출함
                    self.nowPlayingRelay.accept(nowItems)
                    self.popularRelay.accept(popItems)
                    self.topRatedRelay.accept(topItems)
                    self.upcomingRelay.accept(upcItems)
                },
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
