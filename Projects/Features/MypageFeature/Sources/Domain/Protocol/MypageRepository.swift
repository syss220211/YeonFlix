//
//  MypageRepository.swift
//  MypageFeature
//
//  Created by 박서연 on 1/28/26.
//  Copyright © 2026 linda. All rights reserved.
//

import CoreModels

public protocol MypageRepository {
    func fetchFavoriteMovies() async throws -> [FavoriteMovieEntity]
}
