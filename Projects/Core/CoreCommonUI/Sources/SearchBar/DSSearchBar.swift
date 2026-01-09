//
//  DSSearchBar.swift
//  CoreCommonUI
//
//  Created by 박서연 on 1/8/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

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
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let clearButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.contentMode = .center
        return btn
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
        
        setLeadingIcon(DSImage.search.image)
        setClearIcon(DSImage.fillClose.image)
        
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
    
    // MARK: - 레이아웃 설정
    public func setLeadingIcon(_ image: UIImage?) {
        leadingIconView.image = image?.withRenderingMode(.alwaysTemplate)
    }
    
    public func setClearIcon(_ image: UIImage?) {
        clearButton.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
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
        containerView.translatesAutoresizingMaskIntoConstraints = false
        leadingIconView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: config.height),
            
            leadingIconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: config.horizontalPadding),
            leadingIconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            leadingIconView.widthAnchor.constraint(equalToConstant: config.iconSize),
            leadingIconView.heightAnchor.constraint(equalToConstant: config.iconSize),
            
            clearButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -config.horizontalPadding),
            clearButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: config.clearIconSize),
            clearButton.heightAnchor.constraint(equalToConstant: config.clearIconSize),
            
            textField.leadingAnchor.constraint(equalTo: leadingIconView.trailingAnchor, constant: config.spacing),
            textField.trailingAnchor.constraint(equalTo: clearButton.leadingAnchor, constant: -config.spacing),
            textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
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
        clearButton.tintColor = s.clearIconColor
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
