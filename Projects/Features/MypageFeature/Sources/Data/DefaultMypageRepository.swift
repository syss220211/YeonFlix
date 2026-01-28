//
//  DefaultMypageRepository.swift
//  MypageFeature
//
//  Created by 박서연 on 1/29/26.
//  Copyright © 2026 linda. All rights reserved.
//

import CoreModels
import CorePersistence

public final class DefaultMypageRepository: MypageRepository {
    private let localManager: FavoriteMovieManager
    
    public init(localManager: FavoriteMovieManager) {
        self.localManager = localManager
    }
    
    public func fetchFavoriteMovies() async throws -> [FavoriteMovieEntity] {
        return try await localManager.getFavoriteMovies()
    }
}
