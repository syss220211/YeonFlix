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
import CoreCommonUI

public final class TestSearchViewController: UIViewController {

    private let searchBar = DSSearchBar(style: .darkDefault, configuration: .default)

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Movie Search"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()

    private let searchResultLabel: UILabel = {
        let label = UILabel()
        label.text = "검색어를 입력하세요"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Search bar에 텍스트를 입력하면\n여기에 검색 결과가 표시됩니다"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.textColor = .tertiaryLabel
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Lifecycle
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
        setupSearchBar()
    }

    // MARK: - Setup
    private func setupUI() {
        navigationItem.title = "Movie Search"
        view.backgroundColor = DesignSystemColor.background

        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(searchResultLabel)
        view.addSubview(instructionLabel)

//        searchBar.placeholder = "Search"
    }

    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        searchResultLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(searchResultLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    private func setupSearchBar() {
        searchBar.onTextChanged = { [weak self] text in
            self?.handleSearchTextChanged(text)
        }

        searchBar.onBeginEditing = { [weak self] in
            self?.handleSearchBegin()
        }

        searchBar.onEndEditing = { [weak self] in
            self?.handleSearchEnd()
        }

        searchBar.onClearTapped = { [weak self] in
            self?.handleSearchCleared()
        }

        searchBar.onReturn = { [weak self] text in
            self?.handleSearchSubmit(text)
        }
    }

    // MARK: - Search Handlers
    private func handleSearchTextChanged(_ text: String) {
        if text.isEmpty {
            searchResultLabel.text = "검색어를 입력하세요"
            searchResultLabel.textColor = .secondaryLabel
        } else {
            searchResultLabel.text = "검색 중: \"\(text)\""
            searchResultLabel.textColor = .label
        }
    }

    private func handleSearchBegin() {
        instructionLabel.text = "입력을 시작했습니다"
    }

    private func handleSearchEnd() {
        instructionLabel.text = "검색 종료"
    }

    private func handleSearchCleared() {
        searchResultLabel.text = "검색어가 삭제되었습니다"
        searchResultLabel.textColor = .secondaryLabel
        instructionLabel.text = "Search bar에 텍스트를 입력하면\n여기에 검색 결과가 표시됩니다"
    }

    private func handleSearchSubmit(_ text: String) {
        searchResultLabel.text = "검색 완료: \"\(text)\"\n검색 결과를 표시합니다"
        searchResultLabel.textColor = .systemBlue
        searchBar.blur()
    }
}
