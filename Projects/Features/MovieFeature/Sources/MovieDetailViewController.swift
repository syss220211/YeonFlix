//
//  MovieDetailViewController.swift
//  MovieFeature
//
//  Created by 박서연 on 12/30/25.
//  Copyright © 2025 linda. All rights reserved.
//

import UIKit
import SnapKit

import DesignSystem

public final class MovieDetailViewController: UIViewController {

    private let movieID: Int

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Movie Detail"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()

    private let movieIDLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "This is a test movie detail screen.\nMovie ID is displayed below:"
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    public init(movieID: Int) {
        self.movieID = movieID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        configureData()
    }

    private func setupUI() {
        view.backgroundColor = DesignSystemColor.background
        navigationItem.title = "Movie Detail"

        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(movieIDLabel)
    }

    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        movieIDLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    private func configureData() {
        movieIDLabel.text = "Movie ID: \(movieID)"
    }
}
