//
//  URLSessionProtocol.swift
//  CoreModels
//
//  Created by 박서연 on 12/18/25.
//  Copyright © 2025 linda. All rights reserved.
//

import Foundation

public protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
