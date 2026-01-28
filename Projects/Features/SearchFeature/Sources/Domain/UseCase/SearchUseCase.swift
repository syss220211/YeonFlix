//
//  SearchUseCase.swift
//  SearchFeature
//
//  Created by 박서연 on 1/27/26.
//  Copyright © 2026 linda. All rights reserved.
//

import CoreModels
import CoreNetwork

public protocol SearchUseCase {
    func fetchPopularMovies(page: Int) async throws -> PaginatedEntity<PopularMoviesEntity>
    func fetchSearchMovies(query: String, page: Int) async throws -> PaginatedEntity<MovieSearchEntity>
}

public final class DefaultSearchUseCase: SearchUseCase {
    private let repository: SearchRepository
    
    public init(repository: SearchRepository) {
        self.repository = repository
    }
    
    public func fetchPopularMovies(page: Int) async throws -> PaginatedEntity<PopularMoviesEntity> {
        return try await repository.fetchPopularMovies(page: page)
    }
    
    public func fetchSearchMovies(query: String, page: Int) async throws -> PaginatedEntity<MovieSearchEntity> {
        return try await repository.fetchSearchMovies(query: query, page: page)
    }
}
