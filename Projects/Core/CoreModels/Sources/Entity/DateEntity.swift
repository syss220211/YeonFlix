//
//  DateEntity.swift
//  CoreModels
//
//  Created by 박서연 on 12/23/25.
//  Copyright © 2025 linda. All rights reserved.
//

import Foundation

public struct DateEntity: Decodable, Sendable {
    public let maximum: String
    public let minimum: String
    
    public init(
        maximum: String,
        minimum: String
    ) {
        self.maximum = maximum
        self.minimum = minimum
    }
    
    public init() {
        self.maximum = ""
        self.minimum = ""
    }
}
