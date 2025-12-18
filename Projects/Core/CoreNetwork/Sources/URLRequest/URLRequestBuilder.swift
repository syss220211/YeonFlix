//
//  URLRequestBuilder.swift
//  CoreModels
//
//  Created by 박서연 on 12/18/25.
//  Copyright © 2025 linda. All rights reserved.
//

import Foundation

public protocol URLRequestBuilder {
    func build(
        endpoint: Endpoint,
        config: APIConfig
    ) -> Result<URLRequest, NetworkError>
}

public final class DefaultURLRequestBuilder: URLRequestBuilder {

    public init() {}

    public func build(
        endpoint: Endpoint,
        config: APIConfig
    ) -> Result<URLRequest, NetworkError> {

        let url = config.baseURL.appendingPathComponent(endpoint.path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)

        var queryItems = config.defaultQueryItems
        if let endpointItems = endpoint.queryItems {
            queryItems.append(contentsOf: endpointItems)
        }
        components?.queryItems = queryItems

        guard let finalURL = components?.url else {
            return .failure(.invalidURL)
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        config.defaultHeaders.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }

        endpoint.headers?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }

        return .success(request)
    }
}
