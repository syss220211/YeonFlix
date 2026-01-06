//
//  AppDelegate.swift
//  YeonFlixApp
//
//  Created by 박서연 on 11/27/25.
//  Copyright © 2025 linda. All rights reserved.
//

import UIKit

import HomeFeature
import DesignSystem

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        DesignSystemFontFamily.registerAllCustomFonts()
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}
