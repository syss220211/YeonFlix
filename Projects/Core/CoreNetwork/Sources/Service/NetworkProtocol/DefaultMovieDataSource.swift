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
    public func fetchPlayingMovies(page: Int) async throws -> NowPlayingResponseDTO {
        let endPoint = Movie.nowPlaying(page: page)
        return try await networkService.request(endpoint: endPoint)
    }
}
