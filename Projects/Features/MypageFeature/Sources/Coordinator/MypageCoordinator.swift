//
//  MypageCoordinator.swift
//  MypageFeature
//
//  Created by 박서연 on 1/29/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

@MainActor
public final class MypageCoordinator {
    public weak var navigationController: UINavigationController?
    private weak var presentedNavigationController: UINavigationController?
    public weak var delegate: MypageControllerDelegate?
    private let diContainer: MypageDIContainer
    
    public init(
        navigationController: UINavigationController? = nil,
        delegate: MypageControllerDelegate? = nil,
        diContainer: MypageDIContainer
    ) {
        self.navigationController = navigationController
        self.delegate = delegate
        self.diContainer = diContainer
    }
    
    public func start() {
        let viewModel = diContainer.makeMypageViewModel()
        let vc = MypageViewController(viewModel: viewModel)
        vc.delegate = self
        
        navigationController?.pushViewController(vc, animated: false)
    }
}

extension MypageCoordinator: MypageControllerDelegate {
    public func mypageControllerSelectedSavedMovie(_ movieID: Int) {
        delegate?.mypageControllerSelectedSavedMovie(movieID)
    }
}
