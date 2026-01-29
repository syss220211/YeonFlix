//
//  DefaultMovieDetailRepository.swift
//  MovieFeature
//
//  Created by 박서연 on 1/23/26.
//  Copyright © 2026 linda. All rights reserved.
//

import CoreModels
import CoreNetwork
import CorePersistence

public final class DefaultMovieDetailRepository: MovieDetailRepository {
    
    private let remoteNetwork: MovieNetworkDataSource
    private let localStorage: FavoriteMovieManager
    
    public init(
        remoteNetwork: MovieNetworkDataSource,
        localStorage: FavoriteMovieManager
    ) {
        self.remoteNetwork = remoteNetwork
        self.localStorage = localStorage
    }
    
    public func fetchMovieDetails(movieID: Int) async throws -> CoreModels.MovieDetailBundleEntity {
        return try await remoteNetwork.fetchMovieDetails(movieId: movieID).toDomain()
    }
    
    public func fetchSimilarMovies(movieId: Int, page: Int) async throws -> PaginatedEntity<SimilarMoviesEntity> {
        return try await remoteNetwork.fetchSimilarMovies(movieId: movieId, page: page).toDomain()
    }
    
    public func toggleMovieFavorite(movie: FavoriteMovieEntity) async throws {
        return try await localStorage.toggleFavorite(
            movieID: movie.movieID,
            title: movie.title,
            posterPath: movie.posterPath,
            movieDescription: movie.movieDescription
        )
    }
    
}
