//
//  MovieCreditsEntity.swift
//  CoreModels
//
//  Created by 박서연 on 1/23/26.
//  Copyright © 2026 linda. All rights reserved.
//

public struct MovieCreditsEntity: Sendable, Equatable {
    public let cast: [MovieCastEntity]
    public let crew: [MovieCrewEntity]

    public init(
        cast: [MovieCastEntity],
        crew: [MovieCrewEntity]
    ) {
        self.cast = cast
        self.crew = crew
    }
}

public struct MovieCrewEntity: Sendable, Equatable {
    public let id: Int?
    public let name: String
    public let job: String?
    public let department: String?
    public let profilePath: String?

    public init(
        id: Int?,
        name: String,
        job: String?,
        department: String?,
        profilePath: String?
    ) {
        self.id = id
        self.name = name
        self.job = job
        self.department = department
        self.profilePath = profilePath
    }
}

public struct MovieCastEntity: Sendable, Equatable {
    public let id: Int?
    public let name: String
    public let character: String?
    public let profilePath: String?
    public let order: Int?

    public init(
        id: Int?,
        name: String,
        character: String?,
        profilePath: String?,
        order: Int?
    ) {
        self.id = id
        self.name = name
        self.character = character
        self.profilePath = profilePath
        self.order = order
    }
}
