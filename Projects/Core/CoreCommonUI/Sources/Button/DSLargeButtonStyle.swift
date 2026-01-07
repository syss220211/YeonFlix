//
//  DSLargeButtonStyle.swift
//  CoreCommonUI
//
//  Created by 박서연 on 1/6/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit
import SnapKit

public final class DSLargeButton: UIButton {

    private let buttonStyle: DSLargeButtonStyle
    private let buttonConfig: DSLargeButtonConfiguration

    private let enabledBackgroundColor: UIColor
    private let disabledBackgroundColor: UIColor
    private let enabledForegroundColor: UIColor
    private let disabledForegroundColor: UIColor

    private var isLoadingState: Bool = false
    private var originalTitle: String?

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    public init(
        buttonStyle: DSLargeButtonStyle,
        buttonConfig: DSLargeButtonConfiguration = .medium
    ) {
        self.buttonStyle = buttonStyle
        self.buttonConfig = buttonConfig
        
        let colors = buttonStyle.colors
        self.enabledBackgroundColor = colors.enabledBackground
        self.disabledBackgroundColor = colors.disabledBackground
        self.enabledForegroundColor = colors.enabledForeground
        self.disabledForegroundColor = colors.disabledForeground

        super.init(frame: .zero)

        setupLayout()
        setupConfiguration()
        setupStateHandler()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupLayout() {
        addSubview(activityIndicator)

        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Initial Configuration (고정값)
    private func setupConfiguration() {
        var config = UIButton.Configuration.filled()

        config.background.cornerRadius = buttonConfig.cornerRadius
        config.contentInsets = NSDirectionalEdgeInsets(
            top: buttonConfig.verticalPadding,
            leading:  buttonConfig.horizontalPadding,
            bottom: buttonConfig.verticalPadding,
            trailing: buttonConfig.horizontalPadding
        )

        config.imagePlacement = .leading
        config.imagePadding = 8
        config.titleAlignment = .center
        config.titleTextAttributesTransformer =
            UIConfigurationTextAttributesTransformer { [weak self] incoming in
                guard let self else { return incoming }
                var outgoing = incoming
                outgoing.font = self.buttonConfig.font.font
                return outgoing
            }
        
        // 이미지 크기 고정
        let imageSize = buttonConfig.imageSize
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: imageSize)
        configuration = config
    }

    // MARK: - State Handler (변하는 값)

    private func setupStateHandler() {
        configurationUpdateHandler = { [weak self] button in
            guard let self else { return }
            guard var config = button.configuration else { return }

            let isActive = button.isEnabled && !self.isLoadingState

            let backgroundColor = isActive
                ? self.enabledBackgroundColor
                : self.disabledBackgroundColor

            let foregroundColor = isActive
                ? self.enabledForegroundColor
                : self.disabledForegroundColor

            config.background.backgroundColor = backgroundColor
            config.baseForegroundColor = foregroundColor
            config.image?.withTintColor(foregroundColor)
            config.image?.resizableImage(withCapInsets: .init(top: 8, left: 20, bottom: 8, right: 20))
            config.titleTextAttributesTransformer =
                UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
                    outgoing.font = self.buttonConfig.font.font
                    outgoing.foregroundColor = foregroundColor
                    return outgoing
                }

            button.configuration = config
            self.activityIndicator.color = foregroundColor
        }
    }

    // MARK: - Loading State

    public func setLoading(_ loading: Bool) {
        guard isLoadingState != loading else { return }
        isLoadingState = loading

        if loading {
            originalTitle = configuration?.title
            var config = configuration
            config?.title = nil
            config?.image = nil
            configuration = config

            activityIndicator.startAnimating()
            isUserInteractionEnabled = false
        } else {
            var config = configuration
            config?.title = originalTitle
            configuration = config

            activityIndicator.stopAnimating()
            isUserInteractionEnabled = true
        }

        setNeedsUpdateConfiguration()
    }

    // MARK: - Layout Size

    public override var intrinsicContentSize: CGSize {
        let base = super.intrinsicContentSize
        return CGSize(width: base.width, height: buttonConfig.height)
    }
}

extension DSLargeButton {
    public func updateTitle(_ title: String?) {
        var config = configuration
        config?.title = title
        configuration = config
    }

    public func updateImage(_ image: UIImage?) {
        var config = configuration
        config?.image = image?.withRenderingMode(.alwaysTemplate)
        configuration = config
    }
}
