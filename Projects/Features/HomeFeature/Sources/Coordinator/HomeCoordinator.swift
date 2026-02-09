//
//  HomeCoordinator.swift
//  HomeFeature
//
//  Created by 박서연 on 12/30/25.
//  Copyright © 2025 linda. All rights reserved.
//

import UIKit

@MainActor
public final class HomeCoordinator {
    
    public weak var navigationController: UINavigationController?
    public weak var delegate: HomeViewControllerDelegate?
    private let diContainer: HomeFeatureDIContainer
    
    public init(
        navigationController: UINavigationController? = nil,
        delegate: HomeViewControllerDelegate? = nil,
        diContainer: HomeFeatureDIContainer
    ) {
        self.navigationController = navigationController
        self.delegate = delegate
        self.diContainer = diContainer
    }
    
    public func start() {
        let vm = diContainer.makeHomeViewModel()
        let vc = HomeViewController(viewModel: vm)

        vc.delegate = self
        navigationController?.pushViewController(vc, animated: false)
    }
}

// MARK: - HomeVC가 보내는 프로토콜 상의 화면 이동에 대한 응답을 하기 위해서 Extension에 HomeViewControllerDelegate 정의
extension HomeCoordinator: HomeViewControllerDelegate {
    // 채택함으로 써 vc.delegate = self 가 성립
    public func homeViewControllerDidSelectedMovie(_ movieID: Int) {
        delegate?.homeViewControllerDidSelectedMovie(movieID)
    }
}
