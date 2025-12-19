//
//  Font.swift
//  DesignSystem
//
//  Created by 박서연 on 12/18/25.
//  Copyright © 2025 linda. All rights reserved.
//

import UIKit

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
