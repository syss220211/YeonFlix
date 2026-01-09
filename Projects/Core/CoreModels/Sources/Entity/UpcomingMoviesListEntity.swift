//
//  UpcomingMoviesListEntity.swift
//  CoreModels
//
//  Created by 박서연 on 1/10/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation

typealias UpcomingMoviesListEntity = PaginatedEntity<UpcomingMoviesEntity>

public struct UpcomingMoviesEntity: Sendable {
    public let adult: Bool
    public let backdropPath: String?
    public let genreIDs: [Int]
    public let id: Int
    public let originalLanguage: String
    public let originalTitle: String
    public let overview: String
    public let popularity: Double
    public let posterPath: String?
    public let releaseDate: String?
    public let title: String
    public let video: Bool
    public let voteAverage: Double
    public let voteCount: Int
}
