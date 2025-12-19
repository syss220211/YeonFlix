//
//  NetworkError.swift
//  CoreModels
//
//  Created by 박서연 on 12/18/25.
//  Copyright © 2025 linda. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case transportError(Error)
    case statusCode(Int, Data?)
    case noData
    case decodingError(Error)
}
