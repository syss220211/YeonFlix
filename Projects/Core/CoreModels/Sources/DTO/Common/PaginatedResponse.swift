//
//  PaginatedResponse.swift
//  CoreModels
//
//  Created by 박서연 on 1/9/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation

public struct PaginatedResponse<T: Sendable & Decodable>: Decodable, Sendable {
    public let page: Int
    public let results: [T]
    public let totalPages: Int
    public let totalResults: Int
    public let dates: DatesDTO?
    
    enum CodingKeys: String, CodingKey {
        case dates
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

public extension PaginatedResponse {

    func toDomain<U>(_ transform: (T) -> U) -> PaginatedEntity<U> {
        return PaginatedEntity(
            page: page,
            results: results.map(transform),
            totalPages: totalPages,
            totalResults: totalResults,
            dates: dates?.toDomain()
        )
    }
}
