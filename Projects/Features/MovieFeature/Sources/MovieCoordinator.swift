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
    
    public init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    public func movieHome(_ movieID: Int) {
        let vc = MovieDetailViewController(movieID: movieID)

        // 화면 Push
        //        vc.hidesBottomBarWhenPushed = true
        //        navigationController?.pushViewController(vc, animated: true)
        
        // 화면 바텀 시트
        vc.modalPresentationStyle = .fullScreen
        
        let nav = UINavigationController(rootViewController: vc)
        navigationController?.present(nav, animated: true)
    }
}
