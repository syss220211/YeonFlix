//
//  AppDelegate.swift
//  YeonFlixApp
//
//  Created by 박서연 on 11/27/25.
//  Copyright © 2025 linda. All rights reserved.
//

import UIKit
import HomeFeature

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let homeVC = HomeViewController()
        let nav = UINavigationController(rootViewController: homeVC)

        window?.rootViewController = nav
        window?.makeKeyAndVisible()

        return true
    }
}
