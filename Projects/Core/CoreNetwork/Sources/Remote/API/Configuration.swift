//
//  Configuration.swift
//  CoreNetwork
//
//  Created by Claude Code on 1/21/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation

/// TMDB Configuration API Endpoint
/// Movie API와 독립적으로 앱 전체의 이미지 설정을 관리
public enum Configuration: Endpoint {
    /// TMDB Configuration 정보 조회
    case tmdb

    /// API Key 필요 여부
    public var requiresKey: Bool { true }
}

public extension Configuration {
    var path: String {
        switch self {
        case .tmdb:
            "/configuration"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .tmdb:
            .get
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .tmdb:
            nil
        }
    }

    var headers: [String: String]? {
        return [
            "accept": "application/json"
        ]
    }

    var body: Data? {
        nil
    }
}
