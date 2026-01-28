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
    /// 영화 상세 정보
    case movieDetail(movieID: Int)
    /// 영화의 비디오 정보
    case movieVideos(movieID: Int)
    /// 영화의 Credit 정보 (감독, 출연진)
    case movieCredits(movieID: Int)
    /// 영화 상세 화면 종합 (상세,출연진, 비디오)
    case movieDetailBundle(movieID: Int)
    /// 유사 영화
    case similarMovies(movieID: Int, page: Int)
    /// 영화 검색
    case searchMovie(query: String, page: Int)
    
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
        case .movieDetail(let movieId):
            "/movie/\(movieId)"
        case .movieVideos(let movieID):
            "/movie/\(movieID)/videos"
        case .movieCredits(let movieID):
            "/movie/\(movieID)/credits"
        case .movieDetailBundle(let movieID):
            "/movie/\(movieID)"
        case .similarMovies(let movieID, _):
            "/movie/\(movieID)/similar"
        case .searchMovie:
            "/search/movie"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .nowPlaying(let page), .popularContents(let page), .topRatedMovies(let page), .upcomingMovies(let page), .similarMovies(_, let page):
            return [
                URLQueryItem(name: "language", value: "ko-KR"),
                URLQueryItem(name: "page", value: "\(page)"),
            ]
        case .movieDetail, .movieCredits, .movieVideos:
            return [
                URLQueryItem(name: "language", value: "ko-KR")
            ]
        case .movieDetailBundle:
            return [
                .init(name: "language", value: "ko-KR"),
                .init(name: "append_to_response", value: "videos,credits")
            ]
        case .searchMovie(let query, let page):
            return [
                URLQueryItem(name: "query", value: "\(query)"),
                URLQueryItem(name: "language", value: "ko-KR"),
                URLQueryItem(name: "page", value: "\(page)"),
            ]
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
