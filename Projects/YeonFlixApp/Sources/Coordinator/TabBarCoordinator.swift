//
//  TabBarCoordinator.swift
//  YeonFlixApp
//
//  Created by 박서연 on 12/30/25.
//  Copyright © 2025 linda. All rights reserved.
//

import UIKit

import DesignSystem

import HomeFeature
import SearchFeature
import MovieFeature
import MypageFeature

@MainActor
final class TabBarCoordinator {

    private let tabBarController = UITabBarController()
    private let diContainer: AppDIContainer

    private var homeCoordinator: HomeCoordinator?
    private var searchCoordinator: SearchCoordinator?
    private var movieCoordinator: MovieCoordinator?
    private var mypageCoordinator: MypageCoordinator?

    init(diContainer: AppDIContainer) {
        self.diContainer = diContainer
        applyTabBarAppearance()
    }

    private func applyTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.shadowColor = .clear

        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
        tabBarController.tabBar.isTranslucent = false
        tabBarController.view.backgroundColor = .black
        
        tabBarController.tabBar.tintColor = DesignSystemColor.primaryRedDark
        tabBarController.tabBar.unselectedItemTintColor = .darkGray
    }
    
    func start(in window: UIWindow) {
        window.backgroundColor = .black
        let homeNav = UINavigationController()
        let searchNav = UINavigationController()
        let myPageNav = UINavigationController()
        
        homeNav.view.backgroundColor = .black
        searchNav.view.backgroundColor = .black
        myPageNav.view.backgroundColor = .black
        
        homeCoordinator = HomeCoordinator(
            navigationController: homeNav,
            delegate: self,
            diContainer: HomeFeatureDIContainer(
                movieNetworkDataSource: diContainer.movieNetworkDataSource
            )
        )
        
        searchCoordinator = SearchCoordinator(
            navigationController: searchNav,
            delegate: self,
            diContainer: SearchDIContainer(
                movieNetworkDataSource: diContainer.movieNetworkDataSource
            )
        )

        mypageCoordinator = MypageCoordinator(
            navigationController: myPageNav,
            delegate: self,
            diContainer: MypageDIContainer()
        )

        homeCoordinator?.start()
        searchCoordinator?.start()
        mypageCoordinator?.start()

        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        searchNav.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        myPageNav.tabBarItem = UITabBarItem(title: "My", image: UIImage(systemName: "person"), tag: 2)

        tabBarController.viewControllers = [homeNav, searchNav, myPageNav]

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

extension TabBarCoordinator: HomeViewControllerDelegate {
    func homeViewControllerDidSelectedMovie(_ movieID: Int) {
        let movieDIContainer = MovieDIContainer(
            networkService: diContainer.networkService,
            apiConfig: diContainer.apiConfig
        )
        self.movieCoordinator = MovieCoordinator(
            navigationController: homeCoordinator?.navigationController,
            diContainer: movieDIContainer
        )
        movieCoordinator?.movieHome(movieID)
    }
}

extension TabBarCoordinator: SearchMovieControllerDelegate, MypageControllerDelegate {
    func searchMovieDetailControllerDidSelectedMovieResult(_ movieID: Int) {
        let movieDIContainer = MovieDIContainer(
            networkService: diContainer.networkService,
            apiConfig: diContainer.apiConfig
        )
        self.movieCoordinator = MovieCoordinator(
            navigationController: searchCoordinator?.navigationController,
            diContainer: movieDIContainer
        )
        movieCoordinator?.movieHome(movieID)
    }
    
    func mypageControllerSelectedSavedMovie(_ movieID: Int) {
        let movieDIContainer = MovieDIContainer(
            networkService: diContainer.networkService,
            apiConfig: diContainer.apiConfig
        )
        self.movieCoordinator = MovieCoordinator(
            navigationController: mypageCoordinator?.navigationController,
            diContainer: movieDIContainer
        )
        movieCoordinator?.movieHome(movieID)
    }
}

