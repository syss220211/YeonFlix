//
//  PaginatedEntity.swift
//  CoreModels
//
//  Created by 박서연 on 1/9/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation

public struct PaginatedEntity<T: Sendable>: Sendable {
    public let page: Int
    public let results: [T]
    public let totalPages: Int
    public let totalResults: Int
    public let dates: DateEntity?
}
