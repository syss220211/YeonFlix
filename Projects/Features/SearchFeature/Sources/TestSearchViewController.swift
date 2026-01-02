//
//  TestSearchViewController.swift
//  SearchFeature
//
//  Created by 박서연 on 12/30/25.
//  Copyright © 2025 linda. All rights reserved.
//

import UIKit
import SnapKit

import DesignSystem

public final class TestSearchViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Movie Search Temp View"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
    }

    private func setupUI() {
        view.backgroundColor = DesignSystemColor.background
        navigationItem.title = "Movie Search"

        view.addSubview(titleLabel)
    }

    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
