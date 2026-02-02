//
//  SearchMovieViewModel.swift
//  SearchFeature
//
//  Created by 박서연 on 2/2/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxRelay

import CoreModels

@MainActor
public final class SearchMovieViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
        let searchTextChanged: Observable<String>
    }

    struct Output {
        let popularMovies: Driver<[PopularMoviesEntity]>
        let searchResults: Driver<[MovieSearchEntity]>
        let isLoading: Driver<Bool>
        let errorMessage: Signal<String>
        let searchMode: Driver<SearchViewController.SearchMode>
    }

    private let useCase: SearchUseCase
    private let disposeBag = DisposeBag()

    private let popularMoviesRelay = BehaviorRelay<[PopularMoviesEntity]>(value: [])
    private let searchResultsRelay = BehaviorRelay<[MovieSearchEntity]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorMessageRelay = PublishRelay<String>()
    private let searchModeRelay = BehaviorRelay<SearchViewController.SearchMode>(value: .default)
    
    public init(useCase: SearchUseCase) {
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                owner.fetchPopularMovies(page: 1)
            }
            .disposed(by: disposeBag)

        input.searchTextChanged
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, query in
                if query.isEmpty {
                    owner.searchModeRelay.accept(.default)
                    owner.searchResultsRelay.accept([])
                } else {
                    owner.searchModeRelay.accept(.searching)
                    owner.fetchSearchMovies(query: query, page: 1)
                }
            }
            .disposed(by: disposeBag)

        return Output(
            popularMovies: popularMoviesRelay.asDriver(),
            searchResults: searchResultsRelay.asDriver(),
            isLoading: isLoadingRelay.asDriver(),
            errorMessage: errorMessageRelay.asSignal(),
            searchMode: searchModeRelay.asDriver()
        )
    }

    private func fetchPopularMovies(page: Int) {
        isLoadingRelay.accept(true)

        Task { [useCase] in
            do {
                let response = try await useCase.fetchPopularMovies(page: page)
                popularMoviesRelay.accept(response.results)
            } catch {
                errorMessageRelay.accept(error.localizedDescription)
            }
            isLoadingRelay.accept(false)
        }
    }

    private func fetchSearchMovies(query: String, page: Int) {
        isLoadingRelay.accept(true)

        Task { [useCase] in
            do {
                let response = try await useCase.fetchSearchMovies(query: query, page: page)
                searchResultsRelay.accept(response.results)
            } catch {
                errorMessageRelay.accept(error.localizedDescription)
            }
            isLoadingRelay.accept(false)
        }
    }
}

