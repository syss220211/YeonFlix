//
//  NowPlayingResponseDTO.swift
//  CoreModels
//
//  Created by 박서연 on 12/23/25.
//  Copyright © 2025 linda. All rights reserved.
//

import Foundation

/// /movie/now_playing의 Response DTO 입니다.
public struct NowPlayingResponseDTO: Decodable {
    public let dates: DatesDTO
    public let page: Int
    public let results: [NowPlayMoviesDTO]
    public let totalPages: Int
    public let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

public extension NowPlayingResponseDTO {
    func toDomain() -> NowPlayingEntity {
        return NowPlayingEntity(
            dates: self.dates.toDomain(),
            page: self.page,
            results: self.results.map({ $0.toDomain() }),
            totalPages: self.totalPages,
            totalResults: self.totalResults
        )
    }
}
