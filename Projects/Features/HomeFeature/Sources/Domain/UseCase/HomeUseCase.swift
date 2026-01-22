//
//  DefaultHomeUseCase.swift
//  HomeFeature
//
//  Created by 박서연 on 12/23/25.
//  Copyright © 2025 linda. All rights reserved.
//

import CoreModels
import CoreNetwork

public protocol HomeUseCase {
    func fetchNowPlayingMovies(page: Int) async throws -> PaginatedEntity<NowPlayingMoviesEntity>
    func fetchPopularMovies(page: Int) async throws -> PaginatedEntity<PopularMoviesEntity>
    func fetchTopRateMovies(page: Int) async throws -> PaginatedEntity<TopRateMovieEntity>
    func fetchUpcomingMovies(page: Int) async throws -> PaginatedEntity<UpcomingMoviesEntity>
}

public final class DefaultHomeUseCase: HomeUseCase {
    private let repository: HomeRepository
    
    public init(repository: HomeRepository) {
        self.repository = repository
    }
    
    public func fetchNowPlayingMovies(page: Int) async throws -> PaginatedEntity<NowPlayingMoviesEntity> {
        return try await repository.fetchPlayingMovies(page: page)
    }
    
    public func fetchPopularMovies(page: Int) async throws -> PaginatedEntity<PopularMoviesEntity> {
        return try await repository.fetchPopularMovies(page: page)
    }
    
    public func fetchTopRateMovies(page: Int) async throws -> PaginatedEntity<TopRateMovieEntity> {
        return try await repository.fetchTopRateMovies(page: page)
    }
    
    public func fetchUpcomingMovies(page: Int) async throws -> PaginatedEntity<UpcomingMoviesEntity> {
        return try await repository.fetchUpcomingMovies(page: page)
    }
}
