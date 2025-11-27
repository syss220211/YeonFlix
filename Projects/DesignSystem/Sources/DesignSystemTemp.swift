//
//  DesignSystemTemp.swift
//  Manifests
//
//  Created by 박서연 on 11/27/25.
//

import UIKit

public enum DesignSystemColor {
    public static let primary = UIColor(red: 0.10, green: 0.45, blue: 0.95, alpha: 1.0)
    public static let background = UIColor(white: 0.97, alpha: 1.0)
    public static let danger = UIColor(red: 0.95, green: 0.15, blue: 0.15, alpha: 1.0)
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
import UIKit

public final class DSButton: UIButton {

    public enum Style {
        case primary
        case danger
    }

    public init(style: Style, title: String) {
        super.init(frame: .zero)
        configure(style: style, title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(style: Style, title: String) {
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 8

        switch style {
        case .primary:
            self.backgroundColor = DesignSystemColor.primary
            self.titleLabel?.font = DesignSystemTypography.body(18)
            self.setTitleColor(.white, for: .normal)

        case .danger:
            self.backgroundColor = DesignSystemColor.danger
            self.titleLabel?.font = DesignSystemTypography.body(18)
            self.setTitleColor(.white, for: .normal)
        }
    }
}
