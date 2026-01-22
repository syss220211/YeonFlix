//
//  MovieDetailUseCase.swift
//  MovieFeature
//
//  Created by 박서연 on 1/23/26.
//  Copyright © 2026 linda. All rights reserved.
//

import CoreModels
import CoreNetwork

public protocol MovieDetailUseCase {
    func fetchMovieDetail(movieId: Int) async throws -> MovieDetailBundleEntity
}

public final class DefaultMovieDetailUseCase: MovieDetailUseCase {
    private let repository: MovieDetailRepository
    
    public init(repository: MovieDetailRepository) {
        self.repository = repository
    }
    
    public func fetchMovieDetail(movieId: Int) async throws -> MovieDetailBundleEntity {
        return try await repository.fetchMovieDetails(movieID: movieId)
    }
}
