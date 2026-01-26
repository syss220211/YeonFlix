//
//  MovieDetailBundleEntity.swift
//  CoreModels
//
//  Created by 박서연 on 1/23/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation

public struct MovieDetailBundleEntity: Sendable, Equatable {
    public let detail: MovieDetailEntity
    public let videos: [MovieVideoEntity]
    public let credits: MovieCreditsEntity?

    public init(
        detail: MovieDetailEntity,
        videos: [MovieVideoEntity],
        credits: MovieCreditsEntity?
    ) {
        self.detail = detail
        self.videos = videos
        self.credits = credits
    }
}
