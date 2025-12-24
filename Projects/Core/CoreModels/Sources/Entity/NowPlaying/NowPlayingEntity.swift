//
//  NowPlayingEntity.swift
//  CoreModels
//
//  Created by 박서연 on 12/23/25.
//  Copyright © 2025 linda. All rights reserved.
//

import Foundation

/// /movie/now_playing의 Entity 입니다.
public struct NowPlayingEntity: Decodable, Sendable {
    public let dates: DateEntity
    public let page: Int
    public let results: [NowPlayingMoviesEntity]
    public let totalPages: Int
    public let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    public init(
        dates: DateEntity,
        page: Int,
        results: [NowPlayingMoviesEntity],
        totalPages: Int,
        totalResults: Int
    ) {
        self.dates = dates
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}
