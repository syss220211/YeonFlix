//
//  MovieDetailViewController.swift
//  MovieFeature
//
//  Created by 박서연 on 12/30/25.
//  Copyright © 2025 linda. All rights reserved.
//

import UIKit

import SnapKit
import RxSwift
import RxRelay

import DesignSystem

public final class MovieDetailViewController: UIViewController {

    private let viewModel: MovieDetailViewModel
    private let disposeBag = DisposeBag()

    private let viewDidLoadRelay = PublishRelay<Void>()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()

    public init(viewModel: MovieDetailViewModel) {
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
        bind()

        // viewDidLoad 이벤트 발생
        viewDidLoadRelay.accept(())
    }

    private func setupUI() {
        view.backgroundColor = DesignSystemColor.background
        navigationItem.title = "Movie Detail"

        view.addSubview(titleLabel)
        view.addSubview(loadingLabel)
    }

    private func setupLayout() {
        loadingLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    private func bind() {
        let input = MovieDetailViewModel.Input(
            viewDidLoad: viewDidLoadRelay.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.isLoading
            .drive(with: self) { owner, isLoading in
                owner.loadingLabel.isHidden = !isLoading
                owner.titleLabel.isHidden = isLoading
            }
            .disposed(by: disposeBag)

        output.movieDetail
            .drive(with: self) { owner, movieDetailBundle in
                let detail = movieDetailBundle.detail
                owner.titleLabel.text = """
                ✅ API 호출 성공!

                제목: \(detail.title)
                평점: \(detail.voteAverage ?? 0.0)/10
                러닝타임: \(detail.runtime ?? 0)분

                콘솔 로그를 확인하세요!
                """
            }
            .disposed(by: disposeBag)

        output.errorMessage
            .emit(with: self) { owner, errorMessage in
                owner.titleLabel.text = "❌ 에러 발생\n\n\(errorMessage)"
                owner.titleLabel.isHidden = false
            }
            .disposed(by: disposeBag)
    }
}
