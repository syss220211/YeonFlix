//
//  MovieSearchEntity.swift
//  CoreModels
//
//  Created by 박서연 on 1/27/26.
//  Copyright © 2026 linda. All rights reserved.
//

typealias MovieSearchListEntity = PaginatedEntity<MovieSearchEntity>

public struct MovieSearchEntity: Decodable, Sendable, Hashable {
    public let id: Int
    public let adult: Bool
    public let title: String
    public let originalTitle: String
    public let originalLanguage: String
    public let overview: String
    public let posterPath: String?
    public let backdropPath: String?
    public let genreIds: [Int]
    public let popularity: Double
    public let releaseDate: String
    public let video: Bool
    public let voteAverage: Double
    public let voteCount: Int

    public init(
        id: Int,
        adult: Bool,
        title: String,
        originalTitle: String,
        originalLanguage: String,
        overview: String,
        posterPath: String?,
        backdropPath: String?,
        genreIds: [Int],
        popularity: Double,
        releaseDate: String,
        video: Bool,
        voteAverage: Double,
        voteCount: Int
    ) {
        self.id = id
        self.adult = adult
        self.title = title
        self.originalTitle = originalTitle
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.genreIds = genreIds
        self.popularity = popularity
        self.releaseDate = releaseDate
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}
