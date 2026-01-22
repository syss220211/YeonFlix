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

        print("📡 [NetworkService] Request: \(endpoint.method.rawValue) \(endpoint.path)")

        let (data, response) = try await sessionProvider.session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode)
        else {
            throw NetworkError.invalidResponse
        }

        #if DEBUG
        if let jsonString = String(data: data, encoding: .utf8) {
            print("📡 [NetworkService] Response JSON from \(endpoint.path):")
            print(jsonString)
        } else {
            print("⚠️ [NetworkService] Could not convert response data to string")
        }
        #endif

        do {
            let decoded = try decoder.decode(T.self, from: data)

            #if DEBUG
            print("✅ [NetworkService] Decoding Success: \(T.self)")
            #endif

            return decoded
        } catch {
            #if DEBUG
            print("❌ [NetworkService] Decoding Error")
            print("   Endpoint: \(endpoint.path)")
            print("   Expected Type: \(T.self)")
            print("   Error: \(error)")
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("   Raw JSON:")
                print(jsonString)
            }
            #endif

            throw NetworkError.decodingError(error)
        }
    }
}
