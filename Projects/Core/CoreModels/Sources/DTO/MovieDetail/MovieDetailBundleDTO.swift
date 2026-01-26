//
//  MovieDetailBundleDTO.swift
//  CoreModels
//
//  Created by 박서연 on 1/22/26.
//  Copyright © 2026 linda. All rights reserved.
//


import Foundation

public struct MovieDetailBundleDTO: Decodable, Sendable {

    public let detail: MovieDetailDTO
    public let videos: MovieVideosDTO?
    public let credits: MovieCreditsDTO?

    enum CodingKeys: String, CodingKey {
        case videos
        case credits
    }

    public init(detail: MovieDetailDTO, videos: MovieVideosDTO?, credits: MovieCreditsDTO?) {
        self.detail = detail
        self.videos = videos
        self.credits = credits
    }

    public init(from decoder: Decoder) throws {
        self.detail = try MovieDetailDTO(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.videos = try container.decodeIfPresent(MovieVideosDTO.self, forKey: .videos)
        self.credits = try container.decodeIfPresent(MovieCreditsDTO.self, forKey: .credits)
    }
}

public extension MovieDetailBundleDTO {
    func toDomain() -> MovieDetailBundleEntity {
        MovieDetailBundleEntity(
            detail: detail.toDomain(),
            videos: videos?.toDomain() ?? [],
            credits: credits?.toDomain()
        )
    }
}
