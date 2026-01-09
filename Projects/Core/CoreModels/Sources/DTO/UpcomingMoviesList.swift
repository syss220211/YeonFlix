//
//  UpcomingMoviesList.swift
//  CoreModels
//
//  Created by 박서연 on 1/10/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation

typealias UpcomingMoviesListDTO = PaginatedResponse<UpcomingMoviesDTO>

public extension UpcomingMoviesListDTO {
    func toDomain() -> PaginatedEntity<UpcomingMoviesEntity> {
        return PaginatedEntity<UpcomingMoviesEntity>(
            page: self.page,
            results: self.results.map({ $0.toDomain() }),
            totalPages: self.totalPages,
            totalResults: self.totalResults,
            dates: self.dates?.toDomain()
        )
    }
}

public struct UpcomingMoviesDTO: Decodable, Sendable {
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
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

public extension UpcomingMoviesDTO {
    func toDomain() -> UpcomingMoviesEntity {
        return UpcomingMoviesEntity(
            adult: self.adult,
            backdropPath: self.backdropPath,
            genreIDs: self.genreIDs,
            id: self.id,
            originalLanguage: self.originalLanguage,
            originalTitle: self.originalTitle,
            overview: self.overview,
            popularity: self.popularity,
            posterPath: self.posterPath,
            releaseDate: self.releaseDate,
            title: self.title,
            video: self.video,
            voteAverage: self.voteAverage,
            voteCount: self.voteCount
        )
    }
}
