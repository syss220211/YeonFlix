//
//  HomeCoordinator.swift
//  HomeFeature
//
//  Created by 박서연 on 12/30/25.
//  Copyright © 2025 linda. All rights reserved.
//

import UIKit

@MainActor
public protocol HomeCoordinatorDelegate: AnyObject {
    func homeCoordinatorDidRequestMovieDetail(_ movieID: Int)
}

@MainActor
public final class HomeCoordinator {
    
    public weak var navigationController: UINavigationController?
    public weak var delegate: HomeCoordinatorDelegate?
    private let diContainer: HomeFeatureDIContainer
    
    public init(
        navigationController: UINavigationController? = nil,
        delegate: HomeCoordinatorDelegate? = nil,
        diContainer: HomeFeatureDIContainer
    ) {
        self.navigationController = navigationController
        self.delegate = delegate
        self.diContainer = diContainer
    }
    
    public func start() {
        let vm = diContainer.makeHomeViewModel()
        let vc = HomeViewController(viewModel: vm)
        
        vm.routeToMovieDetail
            .subscribe(onNext: { [weak self] movieID in
                self?.delegate?.homeCoordinatorDidRequestMovieDetail(movieID)
            })
            .disposed(by: vc.disposeBag)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
