//
//  Home.swift
//  CoreNetwork
//
//  Created by 박서연 on 12/18/25.
//  Copyright © 2025 linda. All rights reserved.
//

import Foundation

public enum Home: Endpoint {
    /// 인기 콘텐츠
    case popularContents
    /// 현재 상영 중
    case nowPlaying
    /// 평점 높은 영화
    case topRatedMovies
    /// 개봉 예정 영화
    case upcomingMovies
    
    /// API Key 필참 여부
    public var requiresKey: Bool { true }
}

public extension Home {
    var path: String {
        switch self {
        case .popularContents:
            "/movie/popular"
        case .nowPlaying:
            "/mo"
        case .topRatedMovies:
            "dd"
        case .upcomingMovies:
            "dd"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var body: Data? {
        nil
    }
}
