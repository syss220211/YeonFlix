//
//  DatesDTO.swift
//  CoreModels
//
//  Created by 박서연 on 12/23/25.
//  Copyright © 2025 linda. All rights reserved.
//

import Foundation

public struct DatesDTO: Decodable {
    public let maximum: String
    public let minimum: String
}

public extension DatesDTO {
    func toDomain() -> DateEntity {
        return DateEntity(
            maximum: self.maximum,
            minimum: self.minimum
        )
    }
}
