//
//  MovieSearchEntity.swift
//  CoreModels
//
//  Created by 박서연 on 1/27/26.
//  Copyright © 2026 linda. All rights reserved.
//

typealias MovieSearchListEntity = PaginatedEntity<MovieSearchEntity>

public struct MovieSearchEntity: Decodable, Sendable {
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
    public let mediaType: String
}
