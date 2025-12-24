//
//  HomeFeatureTest.swift
//  Manifests
//
//  Created by 박서연 on 11/26/25.
//

import UIKit

import CoreCommonUI
import CoreNetwork
import DesignSystem

public final class HomeViewController: UIViewController {

    private let testButton = DSButton(style: .primary, title: "Design Test")

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }

    private func setupUI() {
        view.backgroundColor = DesignSystemColor.background
        view.addSubview(testButton)
    }

    private func setupLayout() {
        testButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(52)
        }
    }
}
