//
//  TMDBImageURLBuilder.swift
//  CoreUtils
//
//  Created by Claude Code on 1/21/26.
//  Copyright © 2026 linda. All rights reserved.
//

import Foundation
import CoreModels

/// TMDB 이미지 URL을 생성하는 유틸리티
/// Configuration API로부터 받은 설정을 사용하여 동적으로 이미지 URL을 생성합니다.
@MainActor
public final class TMDBImageURLBuilder {
    public static let shared = TMDBImageURLBuilder()

    private var configuration: TMDBConfigurationEntity?

    // Fallback URL (Configuration 로드 실패 시 사용)
    private let fallbackBaseURL = "https://image.tmdb.org/t/p"

    private init() {}

    /// Configuration Entity를 설정합니다.
    /// - Parameter entity: TMDB Configuration Entity
    public func configure(with entity: TMDBConfigurationEntity) {
        self.configuration = entity
        print("✅ TMDBImageURLBuilder configured with base URL: \(entity.baseURL)")
    }

    /// Poster 이미지 URL을 생성합니다.
    public func posterURL(path: String?, size: PosterSize = .w500) -> URL? {
        guard let path = path else { return nil }

        // Enum 값이 API에서 지원하는지 동적 검증
        let requestedSize = size.rawValue
        let finalSize = validateAndFindBestSize(
            requested: requestedSize,
            availableSizes: configuration?.posterSizes ?? [],
            sizeType: "poster"
        )

        let baseURL = configuration?.baseURL ?? fallbackBaseURL
        return URL(string: "\(baseURL)/\(finalSize)\(path)")
    }

    /// Backdrop 이미지 URL을 생성합니다.
    public func backdropURL(path: String?, size: BackdropSize = .w1280) -> URL? {
        guard let path = path else { return nil }

        let requestedSize = size.rawValue
        let finalSize = validateAndFindBestSize(
            requested: requestedSize,
            availableSizes: configuration?.backdropSizes ?? [],
            sizeType: "backdrop"
        )

        let baseURL = configuration?.baseURL ?? fallbackBaseURL
        return URL(string: "\(baseURL)/\(finalSize)\(path)")
    }

    /// Logo 이미지 URL을 생성합니다.
    public func logoURL(path: String?, size: LogoSize = .w185) -> URL? {
        guard let path = path else { return nil }

        let requestedSize = size.rawValue
        let finalSize = validateAndFindBestSize(
            requested: requestedSize,
            availableSizes: configuration?.logoSizes ?? [],
            sizeType: "logo"
        )

        let baseURL = configuration?.baseURL ?? fallbackBaseURL
        return URL(string: "\(baseURL)/\(finalSize)\(path)")
    }

    /// Profile 이미지 URL을 생성합니다.
    public func profileURL(path: String?, size: ProfileSize = .w185) -> URL? {
        guard let path = path else { return nil }

        let requestedSize = size.rawValue
        let finalSize = validateAndFindBestSize(
            requested: requestedSize,
            availableSizes: configuration?.profileSizes ?? [],
            sizeType: "profile"
        )

        let baseURL = configuration?.baseURL ?? fallbackBaseURL
        return URL(string: "\(baseURL)/\(finalSize)\(path)")
    }

    // MARK: - Private Helper Methods

    /// 요청한 크기가 API에서 지원하는지 검증하고, 지원하지 않으면 가장 가까운 크기를 반환합니다.
    private func validateAndFindBestSize(
        requested: String,
        availableSizes: [String],
        sizeType: String
    ) -> String {
        // Configuration이 로드되지 않았으면 요청한 크기 그대로 사용 (fallback URL 사용)
        guard !availableSizes.isEmpty else {
            return requested
        }

        // 요청한 크기가 API에서 지원되면 그대로 사용
        if availableSizes.contains(requested) {
            return requested
        }

        // 지원하지 않는 크기 → 가장 가까운 크기 찾기
        let closestSize = findClosestSize(requested: requested, available: availableSizes)
        print("⚠️ [\(sizeType)] Size '\(requested)' not available in API response.")
        print("   Using closest size: '\(closestSize)'")
        print("   Available sizes: \(availableSizes.joined(separator: ", "))")

        return closestSize
    }

    /// 요청한 크기와 가장 가까운 크기를 찾습니다.
    private func findClosestSize(requested: String, available: [String]) -> String {
        // "original"이 요청되었거나 사용 가능하면 그것 사용
        if requested == "original" {
            return available.contains("original") ? "original" : (available.last ?? requested)
        }

        // "w500" → 500 숫자 추출
        guard let requestedWidth = extractWidth(from: requested) else {
            // 숫자를 추출할 수 없으면 첫 번째 사용 가능한 크기 반환
            return available.first ?? requested
        }

        // 사용 가능한 크기 중 가장 가까운 너비 찾기
        let closest = available
            .compactMap { size -> (String, Int)? in
                guard let width = extractWidth(from: size) else { return nil }
                let difference = abs(width - requestedWidth)
                return (size, difference)
            }
            .min(by: { $0.1 < $1.1 })

        return closest?.0 ?? available.first ?? requested
    }

    /// 크기 문자열에서 너비 숫자를 추출합니다.
    private func extractWidth(from size: String) -> Int? {
        // "w500" → 500
        // "h632" → 632
        // "original" → nil
        guard size.count > 1 else { return nil }
        let numberPart = String(size.dropFirst())
        return Int(numberPart)
    }

    // MARK: - Public Debug Helpers

    /// 현재 사용 가능한 poster 크기 목록을 반환합니다 (디버깅용).
    public var availablePosterSizes: [String] {
        configuration?.posterSizes ?? []
    }

    /// 현재 사용 가능한 backdrop 크기 목록을 반환합니다 (디버깅용).
    public var availableBackdropSizes: [String] {
        configuration?.backdropSizes ?? []
    }

    /// 현재 사용 가능한 logo 크기 목록을 반환합니다 (디버깅용).
    public var availableLogoSizes: [String] {
        configuration?.logoSizes ?? []
    }

    /// 현재 사용 가능한 profile 크기 목록을 반환합니다 (디버깅용).
    public var availableProfileSizes: [String] {
        configuration?.profileSizes ?? []
    }

    /// Configuration 로드 여부를 확인합니다.
    public var isConfigured: Bool {
        configuration != nil
    }
}

// MARK: - Image Size Enums
public extension TMDBImageURLBuilder {
    enum PosterSize: String {
        case w92 = "w92"
        case w154 = "w154"
        case w185 = "w185"
        case w342 = "w342"
        case w500 = "w500"
        case w780 = "w780"
        case original = "original"
    }

    enum BackdropSize: String {
        case w300 = "w300"
        case w780 = "w780"
        case w1280 = "w1280"
        case original = "original"
    }

    enum LogoSize: String {
        case w45 = "w45"
        case w92 = "w92"
        case w154 = "w154"
        case w185 = "w185"
        case w300 = "w300"
        case w500 = "w500"
        case original = "original"
    }

    enum ProfileSize: String {
        case w45 = "w45"
        case w185 = "w185"
        case h632 = "h632"
        case original = "original"
    }
}
