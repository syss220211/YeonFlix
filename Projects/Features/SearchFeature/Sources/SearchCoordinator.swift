//
//  SearchCoordinator.swift
//  SearchFeature
//
//  Created by 박서연 on 12/30/25.
//  Copyright © 2025 linda. All rights reserved.
//

import UIKit

@MainActor
public final class SearchCoordinator {
    private weak var navigationController: UINavigationController?
    
    public init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let vc = TestSearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
