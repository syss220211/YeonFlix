//
//  DSSearchBarStyle.swift
//  CoreCommonUI
//
//  Created by 박서연 on 1/8/26.
//  Copyright © 2026 linda. All rights reserved.
//

import DesignSystem

public struct DSSearchBarStyle {
    // 상태에 따라 계속 변화하는 style을 리턴
    public let stateStyle: (DSSearchBarState) -> DSSearchBarVisualStyle

    public init(stateStyle: @escaping (DSSearchBarState) -> DSSearchBarVisualStyle) {
        self.stateStyle = stateStyle
    }
}

extension DSSearchBarStyle {
    public static var darkDefault: DSSearchBarStyle {
        DSSearchBarStyle { state in
            switch state {
            case .default:
                return .init(
                    backgroundColor: DesignSystemColor.neutralGreyDark2,
                    textColor: DesignSystemColor.neutralGrey,
                    placeholderColor: DesignSystemColor.neutralGrey,
                    iconColor:  DesignSystemColor.neutralGrey,
                    clearIconColor: DesignSystemColor.neutralGrey,
                    cursorColor:  DesignSystemColor.systemBlue,
                    showsClearButton: false
                )
            case .active:
                return .init(
                    backgroundColor: DesignSystemColor.neutralGreyDark2,
                    textColor: DesignSystemColor.neutralGrey,
                    placeholderColor: DesignSystemColor.neutralGrey,
                    iconColor:  DesignSystemColor.neutralGrey,
                    clearIconColor: DesignSystemColor.neutralGrey,
                    cursorColor:  DesignSystemColor.systemBlue,
                    showsClearButton: false
                )
            case .activeInput:
                return .init(
                    backgroundColor: DesignSystemColor.neutralGreyDark2,
                    textColor: DesignSystemColor.neutralGreyLight3,
                    placeholderColor: DesignSystemColor.neutralGrey,
                    iconColor:  DesignSystemColor.neutralGrey,
                    clearIconColor: DesignSystemColor.neutralGrey,
                    cursorColor:  DesignSystemColor.systemBlue,
                    showsClearButton: true
                )
            case .inactiveInput:
                return .init(
                    backgroundColor: DesignSystemColor.neutralGreyDark2,
                    textColor: DesignSystemColor.neutralGreyLight3,
                    placeholderColor: DesignSystemColor.neutralGrey,
                    iconColor:  DesignSystemColor.neutralGrey,
                    clearIconColor: DesignSystemColor.neutralGrey,
                    cursorColor:  DesignSystemColor.systemBlue,
                    showsClearButton: true
                )
            }
        }
    }
}
