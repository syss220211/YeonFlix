//
//  FavoriteMovieEntity.swift
//  CoreModels
//
//  Created by 박서연 on 1/28/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation

public struct FavoriteMovieEntity: Sendable, Hashable, Equatable {
    public let movieID: Int
    public let title: String
    public let posterPath: String?

    public init(
        movieID: Int,
        title: String,
        posterPath: String?
    ) {
        self.movieID = movieID
        self.title = title
        self.posterPath = posterPath
    }
}
