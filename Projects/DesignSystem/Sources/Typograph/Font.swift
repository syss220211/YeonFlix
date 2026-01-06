//
//  Font.swift
//  DesignSystem
//
//  Created by 박서연 on 12/18/25.
//  Copyright © 2025 linda. All rights reserved.
//

import UIKit

public struct YTypography {
    public let role: TypographyRole
    public let weight: FontWeight
    
    public init(
        role: TypographyRole,
        weight: FontWeight
    ) {
        self.role = role
        self.weight = weight
    }
    
    public var font: UIFont {
        UIFont(
            name: weight.fontName,
            size: role.size
        )!
    }
    
    public var letterSpacing: CGFloat {
        role.letterSpacing
    }
}

public enum FontWeight {
    case light
    case medium
    case bold
    
    public var fontName: String {
        switch self {
        case .light:
            DesignSystemFontFamily.Pretendard.light.name
        case .medium:
            DesignSystemFontFamily.Pretendard.medium.name
        case .bold:
            DesignSystemFontFamily.Pretendard.bold.name
        }
    }
}

public enum TypographyRole {
    case caption2
    case caption1
    case label3
    case label2
    case label1
    case header1
    
    public var size: CGFloat {
        switch self {
        case .caption2: return 10
        case .caption1: return 12
        case .label3:   return 14
        case .label2:   return 16
        case .label1:   return 18
        case .header1:  return 32
        }
    }
    
    public var letterSpacing: CGFloat {
        0.25
    }
}

public extension UIFont {
    static func yFont(_ role: TypographyRole, weight: FontWeight) -> UIFont {
        UIFont(name: weight.fontName, size: role.size)!
    }
}

public extension UILabel {
    func setText(_ text: String, typography: YTypography) {
        font = typography.font
        
        let attributed = NSMutableAttributedString(string: text)
        attributed.addAttribute(
            .kern,
            value: typography.letterSpacing,
            range: NSRange(location: 0, length: text.count)
        )
        attributedText = attributed
    }
}

public enum DesignSystemTypography {

    public static func title(_ size: CGFloat = 24) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .bold)
    }

    public static func body(_ size: CGFloat = 16) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .regular)
    }

    public static func caption(_ size: CGFloat = 12) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .medium)
    }
}
