//
//  SearchFeatureDIContainer.swift
//  SearchFeature
//
//  Created by 박서연 on 1/27/26.
//  Copyright © 2026 linda. All rights reserved.
//

import CoreNetwork

@MainActor
public final class SearchDIContainer {

    private let movieNetworkDataSource: MovieNetworkDataSource
    
    public init(movieNetworkDataSource: MovieNetworkDataSource) {
        self.movieNetworkDataSource = movieNetworkDataSource
    }
    
    // MARK: - Repository
    private func makeMovieSearchRepository() -> SearchRepository {
        return DefaultSearchRepository(remoteNetwork: movieNetworkDataSource)
    }

    // MARK: - UseCase
    private func makeMovieDetailUseCase() -> SearchUseCase {
        return DefaultSearchUseCase(repository: makeMovieSearchRepository())
    }

    // MARK: - ViewModel
    public func makeSearchViewModel() -> SearchMovieViewModel {
        return SearchMovieViewModel(useCase: makeMovieDetailUseCase())
    }
}

