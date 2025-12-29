//
//  HomeFeatureDIContainer.swift
//  YeonFlixApp
//
//  Created by 박서연 on 12/27/25.
//  Copyright © 2025 linda. All rights reserved.
//

import CoreNetwork
import HomeFeature

public final class HomeFeatureDIContainer {
    
    private let movieNetworkDataSource: MovieNetworkDataSource
    
    public init(movieNetworkDataSource: MovieNetworkDataSource) {
        self.movieNetworkDataSource = movieNetworkDataSource
    }
    
    // MARK: - Repository
    private func makeHomeRepository() -> HomeRepository {
        return DefaultHomeRepository(remoteNetwork:
                                        movieNetworkDataSource)
    }
    
    // MARK: - UseCase
    public func makeHomeUseCase() -> HomeUseCase {
        return DefaultHomeUseCase(repository: makeHomeRepository())
    }
}
