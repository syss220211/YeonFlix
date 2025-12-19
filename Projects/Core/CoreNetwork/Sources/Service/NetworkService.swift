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
        endpoint: Endpoint,
        completion: @Sendable @escaping (Result<T, NetworkError>) -> Void
    )
}

public final class DefaultNetworkService: NetworkService {

    private let config: APIConfig
    private let requestBuilder: URLRequestBuilder
    private let sessionProvider: URLSessionProvider
    private let decoder: JSONDecoder

    public init(
        config: APIConfig,
        requestBuilder: URLRequestBuilder = DefaultURLRequestBuilder(),
        sessionProvider: URLSessionProvider = DefaultURLSessionProvider(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.config = config
        self.requestBuilder = requestBuilder
        self.sessionProvider = sessionProvider
        self.decoder = decoder
    }

    public func request<T: Decodable>(
        endpoint: Endpoint,
        completion: @Sendable @escaping (Result<T, NetworkError>) -> Void
    ) {
        let result = requestBuilder.build(endpoint: endpoint, config: config)

        switch result {
        case .failure(let error):
            completion(.failure(error))

        case .success(let request):
            let decoder = self.decoder

            let task = sessionProvider.session.dataTask(with: request) {
                data, response, error in

                if let error {
                    completion(.failure(.transportError(error)))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) else {
                    completion(.failure(.invalidResponse))
                    return
                }

                guard let data else {
                    completion(.failure(.noData))
                    return
                }

                do {
                    let decoded = try decoder.decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }

            task.resume()
        }
    }
}
