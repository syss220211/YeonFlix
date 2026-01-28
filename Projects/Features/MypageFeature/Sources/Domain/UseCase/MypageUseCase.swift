//
//  MypageUseCase.swift
//  MypageFeature
//
//  Created by 박서연 on 1/28/26.
//  Copyright © 2026 linda. All rights reserved.
//

import CoreModels

public protocol MypageUseCase {
    func fetchFavoriteMovies() async throws -> [FavoriteMovieEntity]
}

public final class DefaultMypageUseCase: MypageUseCase {
    private let repository: MypageRepository
    
    public init(repository: MypageRepository) {
        self.repository = repository
    }
    
    public func fetchFavoriteMovies() async throws -> [FavoriteMovieEntity] {
        return try await repository.fetchFavoriteMovies()
    }
}
