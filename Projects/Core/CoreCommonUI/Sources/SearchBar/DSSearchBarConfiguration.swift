//
//  DSSearchBarConfiguration.swift
//  CoreCommonUI
//
//  Created by 박서연 on 1/8/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

import DesignSystem

public struct DSSearchBarConfiguration: Equatable {
    public let height: CGFloat
    public let cornerRadius: CGFloat
    public let horizontalPadding: CGFloat
    public let iconSize: CGFloat
    public let clearIconSize: CGFloat
    public let spacing: CGFloat
    public let font: UIFont

    public init(
        height: CGFloat = 28,
        cornerRadius: CGFloat = 4,
        horizontalPadding: CGFloat = 10,
        iconSize: CGFloat = 16,
        clearIconSize: CGFloat = 16,
        spacing: CGFloat = 8,
        font: UIFont = YTypography(role: .label3, weight: .light).font
    ) {
        self.height = height
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
        self.iconSize = iconSize
        self.clearIconSize = clearIconSize
        self.spacing = spacing
        self.font = font
    }

    public static var `default`: DSSearchBarConfiguration { .init() }
}
