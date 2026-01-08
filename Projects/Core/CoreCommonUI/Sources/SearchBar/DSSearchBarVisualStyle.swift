//
//  DSSearchBarVisualStyle.swift
//  CoreCommonUI
//
//  Created by 박서연 on 1/8/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

public enum DSSearchBarState {
    case `default`          // 포커스 X, 입력 X
    case active             // 포커스 O, 입력 X
    case activeInput        // 포커스 O, 입력 O
    case inactiveInput      // 포커스 X, 입력 O
}

public struct DSSearchBarVisualStyle: Equatable {
    public let backgroundColor: UIColor
    public let textColor: UIColor
    public let placeholderColor: UIColor
    public let iconColor: UIColor
    public let clearIconColor: UIColor
    public let cursorColor: UIColor
    public let showsClearButton: Bool

    public init(
        backgroundColor: UIColor,
        textColor: UIColor,
        placeholderColor: UIColor,
        iconColor: UIColor,
        clearIconColor: UIColor,
        cursorColor: UIColor,
        showsClearButton: Bool
    ) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.iconColor = iconColor
        self.clearIconColor = clearIconColor
        self.cursorColor = cursorColor
        self.showsClearButton = showsClearButton
    }
}
