//
//  DefaultHomeRepository.swift
//  HomeFeature
//
//  Created by 박서연 on 12/23/25.
//  Copyright © 2025 linda. All rights reserved.
//

import CoreModels
import CoreNetwork

public final class DefaultHomeRepository: HomeRepository {
    
    private let remoteNetwork: MovieNetworkDataSource
    
    public init(remoteNetwork: MovieNetworkDataSource) {
        self.remoteNetwork = remoteNetwork
    }
    
    public func fetchPlayingMovies(page: Int) async throws -> PaginatedEntity<NowPlayingMoviesEntity> {
        return try await remoteNetwork.fetchPlayingMovies(page: page).toDomain()
    }
    
    public func fetchPopularMovies(page: Int) async throws -> PaginatedEntity<PopularMoviesEntity> {
        return try await remoteNetwork.fetchPopularMovies(page: page).toDomain()
    }
    
    // 평점 높은 영화
    public func fetchTopRateMovies(page: Int) async throws -> PaginatedEntity<TopRateMovieEntity> {
        return try await remoteNetwork.fetchTopRateMovies(page: page).toDomain()
    }
    
    // 개봉 예정 영화
    public func fetchUpcomingMovies(page: Int) async throws -> PaginatedEntity<UpcomingMoviesEntity> {
        return try await remoteNetwork.fetchUpcomingMovies(page: page).toDomain()
    }
}
