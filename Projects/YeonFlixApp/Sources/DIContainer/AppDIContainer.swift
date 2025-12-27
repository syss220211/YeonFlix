//
//  AppDIContainer.swift
//  YeonFlixApp
//
//  Created by 박서연 on 12/25/25.
//  Copyright © 2025 linda. All rights reserved.
//

import Foundation

import CoreNetwork
import CoreSecurity

final class AppDIContainer {
    
    // MARK: - Configuration
    private lazy var apiConfig: APIConfig = {
        guard let baseURL = URL(string: "https://api.themoviedb.org/3")
        else {
            fatalError("Invalid TMDB base URL")
        }
        
        return APIConfig(
            baseURL: baseURL,
            defaultHeaders: [:],
            defaultQueryItems: []
        )
    }()
    
    // MARK: - Security
    private lazy var apiKeyStore: APIKeyStore = {
        KeychainAPIKeyStore()
    }()
    
    private lazy var authHeaderProvider: AuthHeaderProvider = {
        DefaultAuthHeaderProvider(keyStore: apiKeyStore)
    }()
    
    // Network
    private lazy var urlRequestBuilder: URLRequestBuilder = {
        DefaultURLRequestBuilder(authHeaderProvider: authHeaderProvider)
    }()
    
    private lazy var urlSessionProvider: URLSessionProvider = {
        DefaultURLSessionProvider()
    }()
    
    private lazy var networkService: NetworkService = {
        DefaultNetworkService(
            config: apiConfig,
            requestBuilder: urlRequestBuilder,
            sessionProvider: urlSessionProvider
        )
    }()
    
    // MARK: - DataSource
    private lazy var movieNetworkDataSource: MovieNetworkDataSource = {
        DefaultMovieDataSource(
            networkService: networkService,
            apiConfig: apiConfig
        )
    }()
    
    // MARK: - Feature Containers
    func makeHomeFeatureDIContainer() -> HomeFeatureDIContainer {
        HomeFeatureDIContainer(
            movieNetworkDataSource: movieNetworkDataSource
        )
    }
}
