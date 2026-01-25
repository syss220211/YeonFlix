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

import CoreCommonUI
import DesignSystem
import WebKit

public final class MovieDetailViewController: UIViewController {

    private let viewModel: MovieDetailViewModel
    private let disposeBag = DisposeBag()

    private let youtubeButtonTapRelay = PublishRelay<Void>()
    private let viewDidLoadRelay = PublishRelay<Void>()

    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        return stackView
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .yFont(.label2, weight: .bold)
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .yFont(.caption1, weight: .medium)
        return label
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .yFont(.label3, weight: .bold)
        return label
    }()
    
    private let youtubeButton: DSLargeButton = {
        let button = DSLargeButton(
            buttonStyle: .primaryApp,
            buttonConfig: .large
        )
        button.updateTitle("유튜브에서 자세히 확인하기")
        button.addTarget(self, action: #selector(youtubeButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .yFont(.caption1, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let webView: WKWebView = {
        let config  = WKWebViewConfiguration()
        return WKWebView(frame: .zero, configuration: config)
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
        view.backgroundColor = .black
        infoStackView.addArrangedSubview(movieTitleLabel)
        infoStackView.addArrangedSubview(infoLabel)
        infoStackView.addArrangedSubview(rateLabel)
        
        view.addSubview(webView)
        view.addSubview(infoStackView)
        view.addSubview(loadingLabel)
        view.addSubview(youtubeButton)
        view.addSubview(descriptionLabel)
    }

    private func setupLayout() {
        loadingLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        webView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(210)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        youtubeButton.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(youtubeButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(8)
        }
    }

    private func bind() {
        let input = MovieDetailViewModel.Input(
            viewDidLoad: viewDidLoadRelay.asObservable(),
            youtubeButtonTapped: youtubeButtonTapRelay.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.isLoading
            .drive(with: self) { owner, isLoading in
                owner.loadingLabel.isHidden = !isLoading
                owner.infoStackView.isHidden = isLoading
            }
            .disposed(by: disposeBag)

        output.movieDetail
            .drive(with: self) { owner, movieDetailBundle in
                let detail = movieDetailBundle.detail
                let hour = (detail.runtime ?? 0) / 60
                let minutes = (detail.runtime ?? 0) % 60
                owner.movieTitleLabel.text = detail.title
                owner.infoLabel.text = "\(detail.releaseDate ?? "") 개봉 \(hour)시간 \(minutes)분"
                
                guard let rate = detail.voteAverage else { return }
                owner.rateLabel.text = "평점 \(rate) "
                owner.descriptionLabel.text = detail.overview ?? ""
                
                // Trailer 영상 + 유튜브일때
                if let trailer = movieDetailBundle.videos.first(where: { $0.type == "Trailer" }), trailer.site == "YouTube" {
                    let urlString = "https://www.youtube.com/watch?v=\(trailer.key ?? "")"
                    guard let url = URL(string: urlString) else { return }
                    owner.webView.load(URLRequest(url: url))
                }
            }
            .disposed(by: disposeBag)

        output.openYouTubeURL
            .emit(with: self) { owner, urlString in
                guard let appURL = URL(string: "youtube://watch?v=\(urlString)"),
                      let webURL = URL(string: "https://www.youtube.com/watch?v=\(urlString)") else { return }

                  let targetURL = UIApplication.shared.canOpenURL(appURL) ? appURL : webURL
                  UIApplication.shared.open(targetURL)
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .emit(with: self) { owner, errorMessage in
                print("❌ 에러 발생\n\n\(errorMessage)")
                owner.infoStackView.isHidden = false
            }
            .disposed(by: disposeBag)
    }
    
    @objc
    func youtubeButtonTapped() {
        youtubeButtonTapRelay.accept(())
    }
}
