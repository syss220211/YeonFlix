//
//  SimilarMovieDTO.swift
//  CoreModels
//
//  Created by 박서연 on 1/25/26.
//  Copyright © 2026 linda. All rights reserved.
//

typealias SimilarMovieListDTO = PaginatedResponse<SimilarMovieDTO>

public extension SimilarMovieListDTO {
    func toDomain() -> PaginatedEntity<SimilarMoviesEntity> {
        return PaginatedEntity<SimilarMoviesEntity>(
            page: self.page,
            results: self.results.map({ $0.toDomain() }),
            totalPages: self.totalPages,
            totalResults: self.totalResults,
            dates: self.dates?.toDomain()
        )
    }
}

public struct SimilarMovieDTO: Decodable, Sendable {
    public let adult: Bool
    public let backdropPath: String?
    public let genreID: [Int]
    public let id: Int
    public let originalLanguage: String?
    public let originalTitle: String?
    public let overview: String
    public let popularity: Double
    public let posterPath: String?
    public let releaseDate: String?
    public let title: String?
    public let video: Bool
    public let voteAverage: Double?
    public let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreID = "genre_ids"
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

public extension SimilarMovieDTO {
    func toDomain() -> SimilarMoviesEntity {
        return SimilarMoviesEntity(
            adult: self.adult,
            backdropPath: self.backdropPath,
            genreID: self.genreID,
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
