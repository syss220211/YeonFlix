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
    
    public func fetchPlayingMovies(page: Int) async throws -> NowPlayingEntity {
        return try await remoteNetwork.fetchPlayingMovies(page: page).toDomain()
    }
}
