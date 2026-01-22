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
import CoreUtils

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        DesignSystemFontFamily.registerAllCustomFonts()

        Task {
            await loadTMDBConfiguration()
        }

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

    // MARK: - Private Methods
    private func loadTMDBConfiguration() async {
        do {
            let diContainer = AppDIContainer()
            let dto = try await diContainer.configurationDataSource.fetchConfiguration()
            let entity = dto.toDomain()
            TMDBImageURLBuilder.shared.configure(with: entity)
            print("✅ TMDB Configuration 로드 완료")
        } catch {
            print("⚠️ TMDB Configuration 로드 실패, fallback URL 사용: \(error)")
        }
    }
}
