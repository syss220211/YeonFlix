//
//  MovieSearchDTO.swift
//  CoreModels
//
//  Created by 박서연 on 1/27/26.
//  Copyright © 2026 linda. All rights reserved.
//

typealias MovieSearchListDTO = PaginatedResponse<MovieSearchDTO>

public extension MovieSearchListDTO {
    func toDomain() -> PaginatedEntity<MovieSearchEntity> {
        return PaginatedEntity<MovieSearchEntity>(
            page: self.page,
            results: self.results.map({ $0.toDomain() }),
            totalPages: self.totalPages,
            totalResults: self.totalResults,
            dates: self.dates?.toDomain()
        )
    }
}

public struct MovieSearchDTO: Decodable, Sendable, Equatable {
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

    enum CodingKeys: String, CodingKey {
        case id
        case adult
        case title
        case overview
        case popularity
        case video
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

public extension MovieSearchDTO {
    func toDomain() -> MovieSearchEntity {
        return MovieSearchEntity(
            id: self.id,
            adult: self.adult,
            title: self.title,
            originalTitle: self.originalTitle,
            originalLanguage: self.originalLanguage,
            overview: self.overview,
            posterPath: self.posterPath,
            backdropPath: self.backdropPath,
            genreIds: self.genreIds,
            popularity: self.popularity,
            releaseDate: self.releaseDate,
            video: self.video,
            voteAverage: self.voteAverage,
            voteCount: self.voteCount
        )
    }
}
