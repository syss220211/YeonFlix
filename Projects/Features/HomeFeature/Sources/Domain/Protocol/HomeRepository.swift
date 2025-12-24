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
    func fetchPlayingMovies(page: Int) async throws -> NowPlayingEntity
}
