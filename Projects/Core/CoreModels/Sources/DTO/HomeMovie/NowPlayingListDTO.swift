//
//  NowPlayingListDTO.swift
//  CoreModels
//
//  Created by 박서연 on 12/23/25.
//  Copyright © 2025 linda. All rights reserved.
//

import Foundation

/// /movie/now_playing의 Response DTO 입니다.
typealias NowPlayingListDTO = PaginatedResponse<NowPlayMoviesDTO>

public extension NowPlayingListDTO {
    func toDomain() -> PaginatedEntity<NowPlayingMoviesEntity> {
        return PaginatedEntity<NowPlayingMoviesEntity>(
            page: self.page,
            results: self.results.map({ $0.toDomain() }),
            totalPages: self.totalPages,
            totalResults: self.totalResults,
            dates: self.dates?.toDomain()
        )
    }
}

public struct NowPlayMoviesDTO: Decodable, Sendable {
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
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity, adult
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genreIds = "genre_ids"
    }
}

public extension NowPlayMoviesDTO {
    func toDomain() -> NowPlayingMoviesEntity {
        NowPlayingMoviesEntity(
            id: self.id,
            title: self.title,
            overview: self.overview,
            posterPath: self.posterPath,
            backdropPath: self.backdropPath,
            releaseDate: self.releaseDate,
            voteAverage: self.voteAverage,
            voteCount: self.voteCount,
            genreIds: self.genreIds,
            popularity: self.popularity,
            adult: self.adult
        )
    }
}
