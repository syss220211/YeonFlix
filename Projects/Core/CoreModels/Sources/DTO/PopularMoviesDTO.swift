//
//  PopularMoviesDTO.swift
//  CoreModels
//
//  Created by 박서연 on 1/9/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation

typealias PopularMoviesListDTO = PaginatedResponse<PopularMoviesDTO>

public extension PopularMoviesListDTO {
    func toDomain() -> PaginatedEntity<PopularMoviesEntity> {
        return PaginatedEntity<PopularMoviesEntity>(
            page: self.page,
            results: self.results.map({ $0.toDomain() }),
            totalPages: self.totalPages,
            totalResults: self.totalResults,
            dates: self.dates?.toDomain()
        )
    }
}

public struct PopularMoviesDTO: Decodable, Sendable {
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

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case adult
        case video
        case popularity
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
    }
}

public extension PopularMoviesDTO {
    func toDomain() -> PopularMoviesEntity {
        return PopularMoviesEntity(
            id: self.id,
            title: self.title,
            originalTitle: self.originalTitle,
            overview: self.overview,
            posterPath: self.posterPath,
            backdropPath: self.backdropPath,
            releaseDate: self.releaseDate,
            genreIDs: self.genreIDs,
            voteAverage: self.voteAverage,
            voteCount: self.voteCount,
            popularity: self.popularity,
            adult: self.adult,
            video: self.video,
            originalLanguage: self.originalLanguage
        )
    }
}
