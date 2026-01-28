//
//  ConfigurationNetworkDataSource.swift
//  CoreNetwork
//
//  Created by Claude Code on 1/21/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation
import CoreModels

public protocol ConfigurationNetworkDataSource {
    func fetchConfiguration() async throws -> TMDBConfigurationDTO
}

public final class DefaultConfigurationDataSource: ConfigurationNetworkDataSource {
    private let networkService: NetworkService
    private let apiConfig: APIConfig

    public init(networkService: NetworkService, apiConfig: APIConfig) {
        self.networkService = networkService
        self.apiConfig = apiConfig
    }

    public func fetchConfiguration() async throws -> TMDBConfigurationDTO {
        let endpoint = Configuration.tmdb
        return try await networkService.request(endpoint: endpoint)
    }
}
