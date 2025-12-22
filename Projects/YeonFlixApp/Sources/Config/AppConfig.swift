//
//  AppConfig.swift
//  YeonFlixApp
//
//  Created by 박서연 on 12/22/25.
//  Copyright © 2025 linda. All rights reserved.
//

import Foundation

enum AppConfig {
    static var tmdbAccessToken: String {
        guard let value = Bundle.main.object(
            forInfoDictionaryKey: "TMDB_ACCESS_TOKEN"
        ) as? String else {
            fatalError("TMDB_ACCESS_TOKEN not found in Info.plist")
        }
        return value
    }
}
