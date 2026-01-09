//
//  HomeViewController.swift
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

    private let viewModel: HomeViewModel
    public let disposeBag = DisposeBag()

    private let saveTokenButton = DSButton(style: .primary, title: "Save API Token to Keychain")
    private let testButton = DSButton(style: .primary, title: "Fetch Now Playing Movies")
    private let navigationButton = DSButton(style: .primary, title: "Movie! Detail")

    private let customButtonPrimaryApp = DSLargeButton(buttonStyle: .primaryOnboarding, buttonConfig: .large)
    private let customButtonPrimaryOnboarding = DSLargeButton(buttonStyle: .primaryApp, buttonConfig: .medium)
    private let customButtonSecondaryApp = DSLargeButton(buttonStyle: .secondaryApp, buttonConfig: .small)

    @objc
    func secondaryTapped() {
        print("isItPossibileTapp?")
    }
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        return label
    }()
    
    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = DesignSystemColor.background
        view.addSubview(saveTokenButton)
        view.addSubview(testButton)
        view.addSubview(navigationButton)
        view.addSubview(customButtonPrimaryApp)
        view.addSubview(customButtonPrimaryOnboarding)
        view.addSubview(customButtonSecondaryApp)
        view.addSubview(resultLabel)

        customButtonPrimaryApp.updateTitle("Primary App Style")
        customButtonPrimaryOnboarding.updateTitle("Primary Onboarding Style")
        customButtonSecondaryApp.updateTitle("Secondary App Style")
        customButtonSecondaryApp.updateImage(DSImage.search.image)
        customButtonSecondaryApp.addTarget(self, action: #selector(secondaryTapped), for: .touchUpInside)
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

        navigationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(testButton.snp.bottom).offset(20)
            make.width.equalTo(250)
            make.height.equalTo(52)
        }

        customButtonPrimaryApp.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(navigationButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        customButtonPrimaryOnboarding.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(customButtonPrimaryApp.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        customButtonSecondaryApp.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(customButtonPrimaryOnboarding.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(customButtonSecondaryApp.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    private func bindViewModel() {
        let input = HomeViewModel.Input(
            saveTokenTapped: saveTokenButton.rx.tap.asObservable(),
            fetchMoviesTapped: testButton.rx.tap.asObservable(),
            movieDetailTapped: navigationButton.rx.tap.map { 12345 }
        )

        let output = viewModel.transform(input: input)

        output.resultText
            .drive(resultLabel.rx.text)
            .disposed(by: disposeBag)

        output.isLoading
            .drive(onNext: { [weak self] isLoading in
                self?.testButton.isEnabled = !isLoading
                self?.saveTokenButton.isEnabled = !isLoading
            })
            .disposed(by: disposeBag)

        output.isMoviesFetched
            .drive(onNext: { [weak self] isFetched in
                self?.customButtonPrimaryApp.isEnabled = isFetched
                self?.customButtonPrimaryOnboarding.isEnabled = isFetched
                self?.customButtonSecondaryApp.isEnabled = isFetched
            })
            .disposed(by: disposeBag)
    }
}
