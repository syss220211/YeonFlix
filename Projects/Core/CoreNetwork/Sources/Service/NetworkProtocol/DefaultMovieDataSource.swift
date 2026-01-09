//
//  DefaultMovieDataSource.swift
//  CoreNetwork
//
//  Created by 박서연 on 12/23/25.
//  Copyright © 2025 linda. All rights reserved.
//

import CoreModels

public final class DefaultMovieDataSource: MovieNetworkDataSource {
    
    private let networkService: NetworkService
    private let apiConfig: APIConfig
    
    public init(
        networkService: NetworkService,
        apiConfig: APIConfig
    ) {
        self.networkService = networkService
        self.apiConfig = apiConfig
    }
    
    /// Now Playing Movies, 현재 상영 중인 영화들의 항목을 가져옵니다.
    public func fetchPlayingMovies(page: Int) async throws -> PaginatedResponse<NowPlayMoviesDTO> {
        let endPoint = Movie.nowPlaying(page: page)
        return try await networkService.request(endpoint: endPoint)
    }
    
    /// Popular, 현재 인기 있는 영화들의 항목을 가져옵니다.
    public func fetchPopularMovies(page: Int) async throws -> PaginatedResponse<PopularMoviesDTO> {
        let endPoint = Movie.popularContents(page: page)
        return try await networkService.request(endpoint: endPoint)
    }
    
    /// Top Rated, 현재 최상위 평점의 영화들의 항목을 가져옵니다.
    public func fetchTopRateMovies(page: Int) async throws -> PaginatedResponse<TopRateMovieDTO> {
        let endPoint = Movie.topRatedMovies(page: page)
        return try await networkService.request(endpoint: endPoint)
    }
    
    /// UpComing, 곧 개봉하는 영화들의 항목을 가져옵니다.
    public func fetchUpcomingMovies(page: Int) async throws -> PaginatedResponse<UpcomingMoviesDTO> {
        let endPoint = Movie.upcomingMovies(page: page)
        return try await networkService.request(endpoint: endPoint)
    }
}
