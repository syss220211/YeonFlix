//
//  TMDBConfigurationEntity.swift
//  CoreModels
//
//  Created by Claude Code on 1/21/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation

public struct TMDBConfigurationEntity: Sendable, Hashable {
    public let baseURL: String
    public let posterSizes: [String]
    public let backdropSizes: [String]
    public let logoSizes: [String]
    public let profileSizes: [String]
    public let stillSizes: [String]

    public init(
        baseURL: String,
        posterSizes: [String],
        backdropSizes: [String],
        logoSizes: [String],
        profileSizes: [String],
        stillSizes: [String]
    ) {
        self.baseURL = baseURL
        self.posterSizes = posterSizes
        self.backdropSizes = backdropSizes
        self.logoSizes = logoSizes
        self.profileSizes = profileSizes
        self.stillSizes = stillSizes
    }
}
