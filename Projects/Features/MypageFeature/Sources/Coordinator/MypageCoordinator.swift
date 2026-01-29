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
    private let diContainer: MypageDIContainer
    
    public init(
        navigationController: UINavigationController? = nil,
        diContainer: MypageDIContainer
    ) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    public func start() {
        let viewModel = diContainer.makeMypageViewModel()
        let vc = MypageViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(vc, animated: false)
    }
}
