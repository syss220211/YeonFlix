//
//  NetworkService.swift
//  CoreModels
//
//  Created by 박서연 on 12/18/25.
//  Copyright © 2025 linda. All rights reserved.
//

import Foundation

public protocol NetworkService {
    func request<T: Decodable>(
        endpoint: Endpoint
    ) async throws -> T
}

public final class DefaultNetworkService: NetworkService {

    private let config: APIConfig
    private let requestBuilder: URLRequestBuilder
    private let sessionProvider: URLSessionProvider
    private let decoder: JSONDecoder

    public init(
        config: APIConfig,
        requestBuilder: URLRequestBuilder,
        sessionProvider: URLSessionProvider,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.config = config
        self.requestBuilder = requestBuilder
        self.sessionProvider = sessionProvider
        self.decoder = decoder
    }
    
    public func request<T: Decodable>(
        endpoint: Endpoint
    ) async throws -> T {
        let request = try requestBuilder
            .build(endpoint: endpoint, config: config)
            .get()
        
        let (data, response) = try await sessionProvider.session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode)
        else {
            throw NetworkError.invalidResponse
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
