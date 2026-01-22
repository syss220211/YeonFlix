//
//  TMDBConfigurationDTO.swift
//  CoreModels
//
//  Created by Claude Code on 1/21/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation

public struct TMDBConfigurationDTO: Decodable, Sendable {
    public let images: ImagesDTO

    public struct ImagesDTO: Decodable, Sendable {
        public let secureBaseUrl: String
        public let backdropSizes: [String]
        public let logoSizes: [String]
        public let posterSizes: [String]
        public let profileSizes: [String]
        public let stillSizes: [String]

        enum CodingKeys: String, CodingKey {
            case secureBaseUrl = "secure_base_url"
            case backdropSizes = "backdrop_sizes"
            case logoSizes = "logo_sizes"
            case posterSizes = "poster_sizes"
            case profileSizes = "profile_sizes"
            case stillSizes = "still_sizes"
        }
    }

    enum CodingKeys: String, CodingKey {
        case images
    }
}

// MARK: - toDomain
public extension TMDBConfigurationDTO {
    func toDomain() -> TMDBConfigurationEntity {
        TMDBConfigurationEntity(
            baseURL: images.secureBaseUrl,
            posterSizes: images.posterSizes,
            backdropSizes: images.backdropSizes,
            logoSizes: images.logoSizes,
            profileSizes: images.profileSizes,
            stillSizes: images.stillSizes
        )
    }
}
