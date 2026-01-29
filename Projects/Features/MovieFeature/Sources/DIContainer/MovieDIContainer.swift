//
//  MovieDIContainer.swift
//  MovieFeature
//
//  Created by 박서연 on 12/30/25.
//  Copyright © 2025 linda. All rights reserved.
//

import UIKit
import CoreNetwork
import CorePersistence

@MainActor
public final class MovieDIContainer {

    private let networkService: NetworkService
    private let apiConfig: APIConfig

    public init(networkService: NetworkService, apiConfig: APIConfig) {
        self.networkService = networkService
        self.apiConfig = apiConfig
    }

    // MARK: - DataSource

    private func makeMovieNetworkDataSource() -> MovieNetworkDataSource {
        return DefaultMovieDataSource(
            networkService: networkService,
            apiConfig: apiConfig
        )
    }

    // MARK: - Repository

    private func makeMovieDetailRepository() -> MovieDetailRepository {
        return DefaultMovieDetailRepository(
            remoteNetwork: makeMovieNetworkDataSource(),
            localStorage: FavoriteMovieManager.shared
        )
    }

    // MARK: - UseCase

    private func makeMovieDetailUseCase() -> MovieDetailUseCase {
        return DefaultMovieDetailUseCase(
            repository: makeMovieDetailRepository()
        )
    }

    // MARK: - ViewModel

    public func makeMovieDetailViewModel(movieID: Int) -> MovieDetailViewModel {
        return MovieDetailViewModel(
            movieID: movieID,
            useCase: makeMovieDetailUseCase()
        )
    }
}
