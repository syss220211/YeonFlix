//
//  HomeFeatureTest.swift
//  Manifests
//
//  Created by 박서연 on 11/26/25.
//

import UIKit

import CoreCommonUI
import CoreNetwork
import CoreSecurity
import DesignSystem

import RxSwift
import RxRelay
import RxCocoa

public final class HomeViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()

    // MARK: - UI Components
    private let saveTokenButton = DSButton(style: .primary, title: "Save API Token to Keychain")
    private let testButton = DSButton(style: .primary, title: "Fetch Now Playing Movies")
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        return label
    }()

    // MARK: - Init
    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        bindViewModel()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = DesignSystemColor.background
        view.addSubview(saveTokenButton)
        view.addSubview(testButton)
        view.addSubview(resultLabel)
    }

    private func setupLayout() {
        saveTokenButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-150)
            make.width.equalTo(250)
            make.height.equalTo(52)
        }

        testButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(saveTokenButton.snp.bottom).offset(20)
            make.width.equalTo(250)
            make.height.equalTo(52)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(testButton.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        // Input
        let input = HomeViewModel.Input(
            saveTokenTapped: saveTokenButton.rx.tap.asObservable(),
            fetchMoviesTapped: testButton.rx.tap.asObservable()
        )

        // Output
        let output = viewModel.transform(input: input)

        // Bind resultText to label
        output.resultText
            .drive(resultLabel.rx.text)
            .disposed(by: disposeBag)

        // Bind loading state (optional - can be used for activity indicator)
        output.isLoading
            .drive(onNext: { [weak self] isLoading in
                self?.testButton.isEnabled = !isLoading
                self?.saveTokenButton.isEnabled = !isLoading
            })
            .disposed(by: disposeBag)
    }
}
