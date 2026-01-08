//
//  DSIconLabelButton.swift
//  CoreCommonUI
//
//  Created by 박서연 on 1/8/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

public final class DSIconLabelButton: UIControl {
    
    private let style: DSIconLabelButtonStyle
    
    private let containerView = UIView()
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        return sv
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    public init(style: DSIconLabelButtonStyle) {
        self.style = style
        super.init(frame: .zero)
        
        setupViews()
        setupLayout()
        applyStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        isAccessibilityElement = true
        accessibilityTraits = .button
        stackView.spacing = style.spacing
        
        addSubview(containerView)
        containerView.addSubview(stackView)
        containerView.isUserInteractionEnabled = false
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
    }
    
    private func setupLayout() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: style.height),
            
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: style.iconSize),
            imageView.heightAnchor.constraint(equalToConstant: style.iconSize)
        ])
    }
    
    private func applyStyle() {
        containerView.backgroundColor = .clear
        imageView.tintColor = style.foregroundColor
        titleLabel.textColor = style.foregroundColor
        titleLabel.font = style.font
    }
    
    public func setImage(_ image: UIImage?) {
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
    }
    
    public func setTitle(_ title: String?) {
        titleLabel.text = title
        accessibilityLabel = title
    }
    
    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: style.height)
    }
}
