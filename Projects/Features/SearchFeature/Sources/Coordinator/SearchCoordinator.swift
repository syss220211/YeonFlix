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
    public weak var navigationController: UINavigationController?
    public weak var delegate: SearchMovieControllerDelegate?
    private weak var presentedNavigationController: UINavigationController?
    private let diContainer: SearchDIContainer
    
    public init(
        navigationController: UINavigationController? = nil,
        delegate: SearchMovieControllerDelegate? = nil,
        diContainer: SearchDIContainer
    ) {
        self.navigationController = navigationController
        self.delegate = delegate
        self.diContainer = diContainer
    }
    
    public func start() {
        let viewModel = diContainer.makeSearchViewModel()
        let vc = SearchViewController(viewModel: viewModel)

        vc.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(vc, animated: false)
        /*
         let vc = TestSearchViewController()
         navigationController?.pushViewController(vc, animated: true)
         */
    }
}

extension SearchCoordinator: SearchMovieControllerDelegate {
    // 검색 영화 상세 화면으로 이동합니다.
    public func searchMovieDetailControllerDidSelectedMovieResult(_ movieID: Int) {
        delegate?.searchMovieDetailControllerDidSelectedMovieResult(movieID)
    }
}
