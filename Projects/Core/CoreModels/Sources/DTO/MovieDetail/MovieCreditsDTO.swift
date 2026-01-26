//
//  MovieCreditsDTO.swift
//  CoreModels
//
//  Created by 박서연 on 1/22/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation

public struct MovieCreditsDTO: Decodable, Sendable {
    public let cast: [MovieCastDTO]
    public let crew: [MovieCrewDTO]
}

public struct MovieCastDTO: Decodable, Sendable {
    public let id: Int?
    public let name: String?
    public let character: String?
    public let profilePath: String?
    public let order: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case character
        case profilePath = "profile_path"
        case order
    }
}

public struct MovieCrewDTO: Decodable, Sendable {
    public let id: Int?
    public let name: String?
    public let job: String?
    public let department: String?
    public let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case job
        case department
        case profilePath = "profile_path"
    }
}

public extension MovieCreditsDTO {
    func toDomain() -> MovieCreditsEntity {
        MovieCreditsEntity(
            cast: cast.map { $0.toDomain() },
            crew: crew.map { $0.toDomain() }
        )
    }
}

public extension MovieCastDTO {
    func toDomain() -> MovieCastEntity {
        MovieCastEntity(
            id: id,
            name: name?.nilIfEmpty ?? "",
            character: character?.nilIfEmpty,
            profilePath: profilePath,
            order: order
        )
    }
}

public extension MovieCrewDTO {
    func toDomain() -> MovieCrewEntity {
        MovieCrewEntity(
            id: id,
            name: name?.nilIfEmpty ?? "",
            job: job?.nilIfEmpty,
            department: department?.nilIfEmpty,
            profilePath: profilePath
        )
    }
}
