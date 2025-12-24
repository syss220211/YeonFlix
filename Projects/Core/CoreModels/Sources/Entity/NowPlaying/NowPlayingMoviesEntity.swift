//
//  NowPlayingMoviesEntity.swift
//  CoreModels
//
//  Created by 박서연 on 12/23/25.
//  Copyright © 2025 linda. All rights reserved.
//

public struct NowPlayingMoviesEntity: Decodable, Sendable {
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
}
