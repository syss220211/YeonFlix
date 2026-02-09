//
//  MypageViewModel.swift
//  MypageFeature
//
//  Created by 박서연 on 1/30/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

import CoreModels

import RxSwift
import RxRelay
import RxCocoa

@MainActor
public final class MypageViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let favortieMovies: Driver<[FavoriteMovieEntity]>
    }
    
    private let favortieMoviesRelay = BehaviorRelay<[FavoriteMovieEntity]>(value: [])
    private let errorMessageRelay = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    private let useCase: MypageUseCase
    
    public init(useCase: MypageUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                owner.fetchFavorieMovies()
            }
            .disposed(by: disposeBag)
        
        return Output(favortieMovies: favortieMoviesRelay.asDriver())
    }
    
    private func fetchFavorieMovies() {
        Task { [useCase] in
            do {
                let response = try await useCase.fetchFavoriteMovies()
                favortieMoviesRelay.accept(response)
            } catch {
                errorMessageRelay.accept(error.localizedDescription)
            }
        }
    }
}
