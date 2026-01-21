//
//  HomeRepository.swift
//  HomeFeature
//
//  Created by 박서연 on 12/23/25.
//  Copyright © 2025 linda. All rights reserved.
//

import CoreModels
import CoreNetwork

public protocol HomeRepository {
    // 현재 상영 중인 영화
    func fetchPlayingMovies(page: Int) async throws -> PaginatedEntity<NowPlayingMoviesEntity>
    // 인기 영화
    func fetchPopularMovies(page: Int) async throws -> PaginatedEntity<PopularMoviesEntity>
    // 평점 높은 영화
    func fetchTopRateMovies(page: Int) async throws -> PaginatedEntity<TopRateMovieEntity>
    // 개봉 예정 영화
    func fetchUpcomingMovies(page: Int) async throws -> PaginatedEntity<UpcomingMoviesEntity>
}
