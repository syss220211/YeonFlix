//
//  Movie.swift
//  CoreNetwork
//
//  Created by 박서연 on 12/18/25.
//  Copyright © 2025 linda. All rights reserved.
//

import Foundation

public enum Movie: Endpoint {
    /// 인기 콘텐츠
    case popularContents(page: Int)
    /// 현재 상영 중
    case nowPlaying(page: Int)
    /// 평점 높은 영화
    case topRatedMovies(page: Int)
    /// 개봉 예정 영화
    case upcomingMovies(page: Int)
    
    /// API Key 필참 여부
    public var requiresKey: Bool { true }
}

public extension Movie {
    var path: String {
        switch self {
        case .popularContents:
            "/movie/popular"
        case .nowPlaying:
            "/movie/now_playing"
        case .topRatedMovies:
            "/movie/top_rated"
        case .upcomingMovies:
            "/movie/upcoming"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .nowPlaying(let page):
            return [
                URLQueryItem(name: "language", value: "ko-KR"),
                URLQueryItem(name: "page", value: "\(page)"),
            ]
        default:
            return nil
        }
    }
    
    var headers: [String : String]? {
        return [
            "accept" : "application/json"
        ]
    }
    
    var body: Data? {
        nil
    }
}
