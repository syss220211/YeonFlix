//
//  MovieNetworkDataSource.swift
//  CoreNetwork
//
//  Created by 박서연 on 12/23/25.
//  Copyright © 2025 linda. All rights reserved.
//

import CoreModels

public protocol MovieNetworkDataSource {
    
    /// Now Playing Movies, 현재 상영 중인 영화들의 항목을 가져옵니다.
    func fetchPlayingMovies(page: Int) async throws -> NowPlayingResponseDTO
    
    /// Popular, 현재 인기 있는 영화들의 항목을 가져옵니다.
    
    
    /// Top Rated, 현재 최상위 평점의 영화들의 항목을 가져옵니다.
    
    
    /// UpComing, 곧 개봉하는 영화들의 항목을 가져옵니다.
    
    
}
