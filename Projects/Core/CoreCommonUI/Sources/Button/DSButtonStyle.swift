//
//  DSLargeButtonStyle.swift
//  CoreCommonUI
//
//  Created by 박서연 on 1/6/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

import DesignSystem

public enum DSButtonStyle {
    case primaryOnboarding
    case primaryApp
    case secondaryApp
    case smallDefault
    
    public struct StyleColors {
        let enabledBackground: UIColor
        let disabledBackground: UIColor
        let enabledForeground: UIColor
        let disabledForeground: UIColor
    }

    public var colors: StyleColors {
        switch self {
        case .primaryOnboarding:
            return StyleColors(
                enabledBackground: DesignSystemColor.primaryRed,
                disabledBackground: DesignSystemColor.neutralGreyLight1,
                enabledForeground: .white,
                disabledForeground: .white
            )
            
        case .primaryApp:
            return StyleColors(
                enabledBackground: .white,
                disabledBackground: .white,
                enabledForeground: .black,
                disabledForeground: DesignSystemColor.neutralGreyLight2
            )
            
        case .secondaryApp:
            return StyleColors(
                enabledBackground: .black,
                disabledBackground: .black,
                enabledForeground: .white,
                disabledForeground: DesignSystemColor.neutralGrey
            )
            
        case .smallDefault:
            return StyleColors(
                enabledBackground: .white,
                disabledBackground: .white,
                enabledForeground: .black,
                disabledForeground: DesignSystemColor.neutralGreyLight2
            )
        }
    }
}

// MARK: - Button Size Definition
public enum DSButtonConfiguration {
    case small
    case medium
    case large
    
    public var height: CGFloat {
        switch self {
        case .small: return 30
        case .medium: return 34
        case .large: return 44
        }
    }
    
    public var font: YTypography {
        switch self {
        case .small, .medium:
            return .init(role: .label3, weight: .medium)
        case .large:
            return .init(role: .label2, weight: .medium)
        }
    }
    
    public var cornerRadius: CGFloat {
        switch self {
        case .large, .small:
            return 2
        case .medium:
            return 4
        }
    }
    
    public var verticalPadding: CGFloat {
        switch self {
        case .large: return 12
        case .medium: return 8
        case .small: return 6
        }
    }
    
    public var horizontalPadding: CGFloat {
        return 20
    }
    
    public var imageSize: CGFloat {
        switch self {
        case .small, .medium: return 18
        case .large: return 20
        }
    }
}
