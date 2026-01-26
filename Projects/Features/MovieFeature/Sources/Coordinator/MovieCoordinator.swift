//
//  MovieCoordinator.swift
//  MovieFeature
//
//  Created by 박서연 on 12/30/25.
//  Copyright © 2025 linda. All rights reserved.
//

import UIKit

@MainActor
public final class MovieCoordinator {
    private weak var navigationController: UINavigationController?
    private weak var presentedNavigationController: UINavigationController?
    public weak var delegate: MovieDetailControllerDelegate?
    private let diContainer: MovieDIContainer

    public init(
        navigationController: UINavigationController?,
        diContainer: MovieDIContainer
    ) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }

    public func movieHome(_ movieID: Int) {
        let viewModel = diContainer.makeMovieDetailViewModel(movieID: movieID)
        let vc = MovieDetailViewController(viewModel: viewModel)
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: false)
        self.presentedNavigationController = nav
        navigationController?.present(nav, animated: true)
    }
}

extension MovieCoordinator: MovieDetailControllerDelegate {
    public func movieDetailControllerDidSelectedSimilarMovie(_ movieID: Int) {
        let viewModel = diContainer.makeMovieDetailViewModel(movieID: movieID)
        let vc = MovieDetailViewController(viewModel: viewModel)
        
        vc.delegate = self
        presentedNavigationController?.setNavigationBarHidden(true, animated: false)
        presentedNavigationController?.pushViewController(vc, animated: true)
    }
}
