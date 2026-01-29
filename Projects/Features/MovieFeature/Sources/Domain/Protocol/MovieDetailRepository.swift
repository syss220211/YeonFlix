//
//  MovieDetailRepository.swift
//  MovieFeature
//
//  Created by 박서연 on 1/23/26.
//  Copyright © 2026 linda. All rights reserved.
//

import CoreModels
import CoreNetwork

public protocol MovieDetailRepository {
    func fetchMovieDetails(movieID: Int) async throws -> MovieDetailBundleEntity
    func fetchSimilarMovies(movieId: Int, page: Int) async throws -> PaginatedEntity<SimilarMoviesEntity>
    
    // 내부 디비
    func toggleMovieFavorite(movie: FavoriteMovieEntity) async throws
}
