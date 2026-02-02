//
//  DSSearchBar.swift
//  CoreCommonUI
//
//  Created by 박서연 on 1/8/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

import SnapKit
import DesignSystem

public final class DSSearchBar: UIView {
    
    public var onTextChanged: ((String) -> Void)?
    public var onBeginEditing: (() -> Void)?
    public var onEndEditing: (() -> Void)?
    public var onClearTapped: (() -> Void)?
    public var onReturn: ((String) -> Void)?
    
    public var text: String {
        get { textField.text ?? "" }
        set {
            textField.text = newValue
            updateDerivedStateAndApply()
        }
    }
    
    public var placeholder: String {
        get { placeholderText }
        set {
            placeholderText = newValue
            applyPlaceholder()
        }
    }
    
    private let style: DSSearchBarStyle
    private let config: DSSearchBarConfiguration
    
    private var placeholderText: String = "Search"
    private var hasFocus: Bool = false
    private var currentState: DSSearchBarState = .default
    
    private let containerView = UIView()
    
    private let leadingIconView: UIImageView = {
        let imageView = UIImageView()
        let originalImage = DSImage.search.image
        let resizedImage = originalImage
            .resized(to: CGSize(width: 16, height: 16))
            .withRenderingMode(.alwaysTemplate)
        imageView.image = resizedImage
        imageView.tintColor = DesignSystemColor.neutralGrey
        return imageView
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton()
        let originalImage = DSImage.fillClose.image
        let resizedImage = originalImage.resized(to: CGSize(width: 16, height: 16))
        button.setImage(resizedImage, for: .normal)
        return button
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.clearButtonMode = .never
        tf.returnKeyType = .search
        return tf
    }()
    
   public init(
        style: DSSearchBarStyle = .darkDefault,
        configuration: DSSearchBarConfiguration = .default
    ) {
        self.style = style
        self.config = configuration
        super.init(frame: .zero)
        
        setupViews()
        setupLayout()
        setupBehaviors()
        updateDerivedStateAndApply()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 키보드
    public func focus() { textField.becomeFirstResponder() }
    public func blur() { textField.resignFirstResponder() }
    public func clear() {
        textField.text = ""
        onTextChanged?("")
        updateDerivedStateAndApply()
    }
    
    private func setupViews() {
        isAccessibilityElement = false
        
        containerView.layer.cornerRadius = config.cornerRadius
        containerView.clipsToBounds = true
        
        textField.font = config.font
        textField.delegate = self
        
        addSubview(containerView)
        containerView.addSubview(leadingIconView)
        containerView.addSubview(textField)
        containerView.addSubview(clearButton)
    }
    
    private func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(config.height)
        }

        leadingIconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(config.horizontalPadding)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(config.iconSize)
        }

        clearButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-config.horizontalPadding)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(config.clearIconSize)
        }

        textField.snp.makeConstraints { make in
            make.leading.equalTo(leadingIconView.snp.trailing).offset(config.spacing)
            make.trailing.equalTo(clearButton.snp.leading).offset(-config.spacing)
            make.centerY.equalToSuperview()
        }
    }
    
    // 버튼 연결 (textfield, clearbutton)
    private func setupBehaviors() {
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
    }
    
    private func resolveState(hasFocus: Bool, hasText: Bool) -> DSSearchBarState {
        switch (hasFocus, hasText) {
        case (false, false): return .default
        case (true, false):  return .active
        case (true, true):   return .activeInput
        case (false, true):  return .inactiveInput
        }
    }
    
    // 조건을 바탕으로 상태 계산 후 UI 재작성
    private func updateDerivedStateAndApply() {
        let hasText = !(textField.text?.isEmpty ?? true)
        let newState = resolveState(hasFocus: hasFocus, hasText: hasText)
        
        let s = style.stateStyle(newState)
        
        containerView.backgroundColor = s.backgroundColor
        textField.textColor = s.textColor
        textField.tintColor = s.cursorColor
        
        leadingIconView.tintColor = s.iconColor
        clearButton.isHidden = !s.showsClearButton
        applyPlaceholder(with: s)
        
        textField.accessibilityLabel = placeholderText
    }
    
    // MARK: - PlaceHolder
    private func applyPlaceholder() {
        let s = style.stateStyle(currentState)
        applyPlaceholder(with: s)
    }
    
    private func applyPlaceholder(with s: DSSearchBarVisualStyle) {
        let attr = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: s.placeholderColor,
                .font: config.font
            ]
        )
        textField.attributedPlaceholder = attr
    }
    
    // MARK: - TextField / Button이 각각 동작해야하는 액션 정의
    @objc private func textDidChange() {
        onTextChanged?(textField.text ?? "")
        updateDerivedStateAndApply()
    }
    
    @objc private func clearTapped() {
        clear()
        onClearTapped?()
    }
}

// MARK: - UITextFieldDelegate
extension DSSearchBar: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        hasFocus = true
        onBeginEditing?()
        updateDerivedStateAndApply()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        hasFocus = false
        onEndEditing?()
        updateDerivedStateAndApply()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturn?(textField.text ?? "")
        textField.resignFirstResponder()
        return true
    }
}
