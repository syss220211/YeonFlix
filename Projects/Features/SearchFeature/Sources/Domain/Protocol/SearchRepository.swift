//
//  SearchRepository.swift
//  SearchFeature
//
//  Created by 박서연 on 1/27/26.
//  Copyright © 2026 linda. All rights reserved.
//

import CoreModels
import CoreNetwork

public protocol SearchRepository {
    func fetchPopularMovies(page: Int) async throws -> PaginatedEntity<PopularMoviesEntity>
    func fetchSearchMovies(query: String, page: Int) async throws -> PaginatedEntity<MovieSearchEntity>
}
