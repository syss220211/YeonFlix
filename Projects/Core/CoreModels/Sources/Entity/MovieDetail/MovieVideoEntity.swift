//
//  MovieVideoEntity.swift
//  CoreModels
//
//  Created by 박서연 on 1/23/26.
//  Copyright © 2026 linda. All rights reserved.
//

public struct MovieVideoEntity: Sendable, Equatable {
    public let id: String?
    public let name: String
    public let key: String?
    public let site: String?
    public let type: String?
    public let official: Bool
    public let publishedAt: String?

    public init(
        id: String?,
        name: String,
        key: String?,
        site: String?,
        type: String?,
        official: Bool,
        publishedAt: String?
    ) {
        self.id = id
        self.name = name
        self.key = key
        self.site = site
        self.type = type
        self.official = official
        self.publishedAt = publishedAt
    }
}
