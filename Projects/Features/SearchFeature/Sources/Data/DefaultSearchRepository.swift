//
//  DefaultSearchRepository.swift
//  SearchFeature
//
//  Created by 박서연 on 1/27/26.
//  Copyright © 2026 linda. All rights reserved.
//

import CoreModels
import CoreNetwork

public final class DefaultSearchRepository: SearchRepository {
    private let remoteNetwork: MovieNetworkDataSource
    
    public init(remoteNetwork: MovieNetworkDataSource) {
        self.remoteNetwork = remoteNetwork
    }
    
    public func fetchPopularMovies(page: Int) async throws -> PaginatedEntity<PopularMoviesEntity> {
        return try await remoteNetwork.fetchPopularMovies(page: page).toDomain()
    }
    
    public func fetchSearchMovies(query: String, page: Int) async throws -> PaginatedEntity<MovieSearchEntity> {
        return try await remoteNetwork.fetchSearchResult(query: query, page: page).toDomain()
    }
}
