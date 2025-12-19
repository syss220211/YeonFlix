//
//  APIConfig.swift
//  CoreModels
//
//  Created by 박서연 on 12/18/25.
//  Copyright © 2025 linda. All rights reserved.
//

import Foundation

public struct APIConfig {
    public let baseURL: URL
    public let defaultHeaders: [String: String]
    public let defaultQueryItems: [URLQueryItem]

    public init(
        baseURL: URL,
        defaultHeaders: [String: String] = [:],
        defaultQueryItems: [URLQueryItem] = []
    ) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
        self.defaultQueryItems = defaultQueryItems
    }
}
