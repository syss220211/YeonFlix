//
//  PopularMoviesEntity.swift
//  CoreModels
//
//  Created by 박서연 on 1/9/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation

typealias PopularMoviesListEntity = PaginatedEntity<PopularMoviesEntity>

public struct PopularMoviesEntity: Sendable {
    public let id: Int
    public let title: String
    public let originalTitle: String
    public let overview: String
    public let posterPath: String?
    public let backdropPath: String?
    public let releaseDate: String?
    public let genreIDs: [Int]
    public let voteAverage: Double
    public let voteCount: Int
    public let popularity: Double
    public let adult: Bool
    public let video: Bool
    public let originalLanguage: String
}
