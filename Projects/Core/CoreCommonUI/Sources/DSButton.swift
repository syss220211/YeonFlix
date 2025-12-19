//
//  DSButton.swift
//  CoreCommonUI
//
//  Created by 박서연 on 12/18/25.
//  Copyright © 2025 linda. All rights reserved.
//

import UIKit

import DesignSystem

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
