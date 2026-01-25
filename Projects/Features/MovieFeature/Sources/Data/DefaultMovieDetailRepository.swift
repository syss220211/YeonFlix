//
//  DefaultMovieDetailRepository.swift
//  MovieFeature
//
//  Created by 박서연 on 1/23/26.
//  Copyright © 2026 linda. All rights reserved.
//

import CoreModels
import CoreNetwork

public final class DefaultMovieDetailRepository: MovieDetailRepository {
    
    private let remoteNetwork: MovieNetworkDataSource
    
    public init(remoteNetwork: MovieNetworkDataSource) {
        self.remoteNetwork = remoteNetwork
    }
    
    public func fetchMovieDetails(movieID: Int) async throws -> CoreModels.MovieDetailBundleEntity {
        return try await remoteNetwork.fetchMovieDetails(movieId: movieID).toDomain()
    }
    
    public func fetchSimilarMovies(movieId: Int, page: Int) async throws -> PaginatedEntity<SimilarMoviesEntity> {
        return try await remoteNetwork.fetchSimilarMovies(movieId: movieId, page: page).toDomain()
    }
}
