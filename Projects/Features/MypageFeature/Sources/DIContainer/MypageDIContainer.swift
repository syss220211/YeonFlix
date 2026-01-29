//
//  MypageDIContainer.swift
//  MypageFeature
//
//  Created by 박서연 on 1/29/26.
//  Copyright © 2026 linda. All rights reserved.
//

import CorePersistence

@MainActor
public final class MypageDIContainer {
    
    public init() { }
    
    // MARK: - Repository
    private func makeMypageRepository() -> MypageRepository {
        return DefaultMypageRepository(localManager: FavoriteMovieManager.shared)
    }

    // MARK: - UseCase
    private func makeMypageUseCase() -> MypageUseCase {
        return DefaultMypageUseCase(repository: makeMypageRepository())
    }
    
    // MARK: - ViewModel
    public func makeMypageViewModel() -> MypageViewModel {
        return MypageViewModel(useCase: self.makeMypageUseCase())
    }
}

