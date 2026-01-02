//
//  HomeDIContainer.swift
//  HomeFeature
//
//  Created by 박서연 on 12/30/25.
//  Copyright © 2025 linda. All rights reserved.
//

import CoreNetwork

public final class HomeFeatureDIContainer {
    
    private let movieNetworkDataSource: MovieNetworkDataSource
    
    public init(movieNetworkDataSource: MovieNetworkDataSource) {
        self.movieNetworkDataSource = movieNetworkDataSource
    }
    
    // MARK: - Repository
    private func makeHomeRepository() -> HomeRepository {
        return DefaultHomeRepository(remoteNetwork: movieNetworkDataSource)
    }
    
    // MARK: - UseCase
    public func makeHomeUseCase() -> HomeUseCase {
        return DefaultHomeUseCase(repository: makeHomeRepository())
    }
    
    // MARK: - ViewModel
    public func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(useCase: self.makeHomeUseCase())
    }
}
