//
//  DSToastView.swift
//  CoreCommonUI
//
//  Created by 박서연 on 2/2/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

import DesignSystem

import SnapKit

public enum ToastType: Sendable {
    case success
    case failure
    case info
}

public final class DSToastView: UIView {
    
    private let type: ToastType
    private let message: String
    
    public init(
        type: ToastType,
        message: String
    ) {
        self.type = type
        self.message = message
        
        super.init(frame: .zero)
        self.label.text = message
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .yFont(.label2, weight: .light)
        label.textColor = .white
        return label
    }()
    
    func setupUI() {
        backgroundColor = backgroundColor(type)
        layer.cornerRadius = 4
        layer.masksToBounds = true
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.trailing.equalToSuperview().offset(15)
        }
    }
    
    private func backgroundColor(_ type: ToastType) -> UIColor {
        switch type {
        case .success:
            return .systemGreen
        case .failure:
            return .systemRed
        case .info:
            return .systemBlue
        }
    }
}

@MainActor
public protocol DSToastMessagePresenting: AnyObject {
    func show(message: String, type: ToastType, view: UIView)
}

public final class DSToastPresenter: DSToastMessagePresenting {
    
    public init() { }
    
    @MainActor
    public func show(message: String, type: ToastType, view: UIView) {
        view.subviews
            .filter { $0 is DSToastView }
            .forEach { $0.removeFromSuperview() }
        
        let toast = DSToastView(type: type, message: message)
        toast.alpha = 0
        view.addSubview(toast)
        
        toast.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.width.equalTo(view.snp.width).multipliedBy(0.85)
        }
        
        UIView.animate(withDuration: 0.2) { toast.alpha = 0.7 }
        UIView.animate(withDuration: 0.2, delay: 1.5) {
            toast.alpha = 0
        } completion: { _ in
            toast.removeFromSuperview()
        }
    }
}
