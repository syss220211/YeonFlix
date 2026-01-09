//
//  DSIconLabelButtonStyle.swift
//  CoreCommonUI
//
//  Created by 박서연 on 1/8/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

import DesignSystem

public enum DSIconLabelButtonStyle {
    case detail    // icon + lightFont
    case featured  // icon + boldFont

    var iconSize: CGFloat {
        switch self {
        case .detail: return 24
        case .featured: return 20
        }
    }

    var font: UIFont {
        switch self {
        case .detail: return YTypography(role: .caption2, weight: .light).font
        case .featured: return YTypography(role: .caption1, weight: .medium).font
        }
    }

    var spacing: CGFloat {
        return 6
    }
    
    var foregroundColor: UIColor {
        switch self {
        case .detail:
            return DesignSystemColor.neutralGrey
        case .featured:
            return .white
        }
    }
    
    var iconColor: UIColor {
        return .white
    }
    
    var height: CGFloat {
        switch self {
        case .detail:
            return 43
        case .featured:
            return 41
        }
    }
}

