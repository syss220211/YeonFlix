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
    func fetchNowPlayingMovies(page: Int) async throws -> NowPlayingEntity
}

public final class DefaultHomeUseCase: HomeUseCase {
    private let repository: HomeRepository
    
    public init(repository: HomeRepository) {
        self.repository = repository
    }
    
    public func fetchNowPlayingMovies(page: Int) async throws -> NowPlayingEntity {
        return try await repository.fetchPlayingMovies(page: page)
    }
}
