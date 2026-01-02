//
//  TabBarCoordinator.swift
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
final class TabBarCoordinator {

    private let tabBarController = UITabBarController()
    private let diContainer: AppDIContainer

    private var homeCoordinator: HomeCoordinator?
    private var searchCoordinator: SearchCoordinator?
    private var movieCoordinator: MovieCoordinator?

    init(diContainer: AppDIContainer) {
        self.diContainer = diContainer
    }

    func start(in window: UIWindow) {
        let homeNav = UINavigationController()
        let searchNav = UINavigationController()
        let myPageNav = UINavigationController()

        homeCoordinator = HomeCoordinator(
            navigationController: homeNav,
            delegate: self,
            diContainer: HomeFeatureDIContainer(
                movieNetworkDataSource: diContainer.movieNetworkDataSource
            )
        )
        
        searchCoordinator = SearchCoordinator()

//        myPageCoordinator = MyPageCoordinator(
//            navigationController: myPageNav,
//            diContainer: MyPageFeatureDIContainer(
//                movieNetworkDataSource: diContainer.movieNetworkDataSource
//            )
//        )

        homeCoordinator?.start()
        searchCoordinator?.start()

        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        searchNav.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        myPageNav.tabBarItem = UITabBarItem(title: "My", image: UIImage(systemName: "person"), tag: 2)

        tabBarController.viewControllers = [homeNav, searchNav, myPageNav]

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

extension TabBarCoordinator: HomeCoordinatorDelegate {
    /// Home -> Movie Feature 으로 이동합니다.
    func homeCoordinatorDidRequestMovieDetail(_ movieID: Int) {
        let movieCoordinator = MovieCoordinator(navigationController: homeCoordinator?.navigationController)
        movieCoordinator.movieHome(movieID)
    }
}

