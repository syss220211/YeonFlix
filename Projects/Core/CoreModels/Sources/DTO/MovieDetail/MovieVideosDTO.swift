//
//  MovieVideosDTO.swift.swift
//  CoreModels
//
//  Created by 박서연 on 1/22/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation

public struct MovieVideosDTO: Decodable, Sendable {
    public let results: [MovieVideoDTO]
}

public struct MovieVideoDTO: Decodable, Sendable {
    public let iso639_1: String?
    public let iso3166_1: String?
    public let name: String?
    public let key: String?
    public let site: String?
    public let size: Int?
    public let type: String?
    public let official: Bool?
    public let publishedAt: String?
    public let id: String?

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name
        case key
        case site
        case size
        case type
        case official
        case publishedAt = "published_at"
        case id
    }
}

// MARK: - Videos DTO -> Entities
public extension MovieVideosDTO {
    func toDomain() -> [MovieVideoEntity] {
        results.map { $0.toDomain() }
    }
}

public extension MovieVideoDTO {
    func toDomain() -> MovieVideoEntity {
        MovieVideoEntity(
            id: id,
            name: name?.nilIfEmpty ?? "",
            key: key,
            site: site,
            type: type,
            official: official ?? false,
            publishedAt: publishedAt
        )
    }
}
