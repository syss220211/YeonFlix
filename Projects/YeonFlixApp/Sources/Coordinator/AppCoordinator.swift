//
//  AppCoordinator.swift
//  YeonFlixApp
//
//  Created by 박서연 on 12/30/25.
//  Copyright © 2025 linda. All rights reserved.
//

import UIKit

import HomeFeature
import SearchFeature
import MovieFeature

@MainActor
final class AppCoordinator {
    private let navigationController = UINavigationController()
    private let diContainer = AppDIContainer()
    private var homeCoordinator: HomeCoordinator?
    private var tabBarCoordinator: TabBarCoordinator?
    
    func start(in window: UIWindow) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let coordinator = TabBarCoordinator(diContainer: diContainer)
        self.tabBarCoordinator = coordinator
        
        coordinator.start(in: window)
    }
}
