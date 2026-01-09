//
//  NowPlayingEntity.swift
//  CoreModels
//
//  Created by 박서연 on 12/23/25.
//  Copyright © 2025 linda. All rights reserved.
//

import Foundation

/// /movie/now_playing의 Entity 입니다.
typealias  NowPlayingListEntity = PaginatedEntity<NowPlayingMoviesEntity>

public struct NowPlayingMoviesEntity: Sendable {
    public let id: Int
    public let title: String
    public let overview: String
    public let posterPath: String?
    public let backdropPath: String?
    public let releaseDate: String?
    public let voteAverage: Double
    public let voteCount: Int
    public let genreIds: [Int]
    public let popularity: Double
    public let adult: Bool
    
    public init(
        id: Int,
        title: String,
        overview: String,
        posterPath: String?,
        backdropPath: String?,
        releaseDate: String?,
        voteAverage: Double,
        voteCount: Int,
        genreIds: [Int],
        popularity: Double,
        adult: Bool
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.genreIds = genreIds
        self.popularity = popularity
        self.adult = adult
    }
    
    public init() {
        self.id = 0
        self.title = ""
        self.overview = ""
        self.posterPath = ""
        self.backdropPath = ""
        self.releaseDate = ""
        self.voteAverage = 0.0
        self.voteCount = 0
        self.genreIds = []
        self.popularity = 0.0
        self.adult = true
    }
}
