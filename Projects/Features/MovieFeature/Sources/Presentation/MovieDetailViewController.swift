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

import CoreUtils
import CoreCommonUI
import CoreModels
import DesignSystem
import WebKit

public final class MovieDetailViewController: UIViewController {
    
    // MARK: - Section
    private enum Section: Int, CaseIterable {
        case detail
        case similar
    }
    
    // MARK: - Props
    private let viewModel: MovieDetailViewModel
    private let disposeBag = DisposeBag()
    
    private let youtubeButtonTapRelay = PublishRelay<Void>()
    private let viewDidLoadRelay = PublishRelay<Void>()
    
    private var movieDetailBundle: MovieDetailBundleEntity?
    private var similarMovies: [SimilarMoviesEntity] = []
    
    // MARK: - Views
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.isHidden = true
        return label
    }()
    
    private let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        return WKWebView(frame: .zero, configuration: config)
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 12, left: 8, bottom: 20, right: 8)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(DetailInfoCell.self, forCellWithReuseIdentifier: DetailInfoCell.identifier)
        cv.register(SimilarMovieCell.self, forCellWithReuseIdentifier: SimilarMovieCell.identifier)
        cv.register(SimilarHeaderView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: SimilarHeaderView.identifier)
        return cv
    }()
    
    // MARK: - Init
    public init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        bind()
        viewDidLoadRelay.accept(())
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(webView)
        view.addSubview(collectionView)
        view.addSubview(loadingLabel)
    }
    
    private func setupLayout() {
        webView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(210)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        loadingLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    private func bind() {
        let input = MovieDetailViewModel.Input(
            viewDidLoad: viewDidLoadRelay.asObservable(),
            youtubeButtonTapped: youtubeButtonTapRelay.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(with: self) { owner, isLoading in
                owner.loadingLabel.isHidden = !isLoading
            }
            .disposed(by: disposeBag)
        
        output.movieDetail
            .drive(with: self) { owner, bundle in
                owner.movieDetailBundle = bundle
                
                // Trailer 영상 + 유튜브일때
                if let trailer = bundle.videos.first(where: { $0.type == "Trailer" && $0.site == "YouTube" }),
                   let key = trailer.key {
                    let urlString = "https://www.youtube.com/watch?v=\(key)"
                    if let url = URL(string: urlString) {
                        owner.webView.load(URLRequest(url: url))
                    }
                }
                
                owner.collectionView.reloadSections(IndexSet(integer: Section.detail.rawValue))
            }
            .disposed(by: disposeBag)
        
        output.similarMovies
            .drive(with: self) { owner, movies in
                owner.similarMovies = movies
                owner.collectionView.reloadSections(IndexSet(integer: Section.similar.rawValue))
            }
            .disposed(by: disposeBag)
        
        output.openYouTubeURL
            .emit(with: self) { owner, videoID in
                guard let appURL = URL(string: "youtube://watch?v=\(videoID)"),
                      let webURL = URL(string: "https://www.youtube.com/watch?v=\(videoID)") else { return }
                
                let targetURL = UIApplication.shared.canOpenURL(appURL) ? appURL : webURL
                UIApplication.shared.open(targetURL)
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .emit(with: self) { owner, errorMessage in
                print("❌ 에러 발생\n\n\(errorMessage)")
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    @objc private func youtubeButtonTapped() {
        youtubeButtonTapRelay.accept(())
    }
    
    private func filterCredits(data: MovieCreditsEntity) -> String {
        let cast = data.cast.prefix(3).map { $0.name }.joined(separator: ", ")
        let crew = data.crew.prefix(3).map { $0.name }.joined(separator: ", ")
        return "출연: \(cast)\n크리에이터: \(crew)"
    }
}

// MARK: - UICollectionViewDataSource
extension MovieDetailViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .detail:
            return 1
        case .similar:
            return similarMovies.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch section {
        case .detail:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailInfoCell.identifier,
                for: indexPath
            ) as! DetailInfoCell
            
            // 데이터 주입
            if let bundle = movieDetailBundle {
                let detail = bundle.detail
                
                let hour = (detail.runtime ?? 0) / 60
                let minutes = (detail.runtime ?? 0) % 60
                
                let title = detail.title ?? "-"
                let info = "\(detail.releaseDate ?? "") 개봉 \(hour)시간 \(minutes)분"
                let rate = detail.voteAverage.map { "평점 \($0)" } ?? "평점 -"
                let overview = detail.overview ?? ""
                
                var creditsText = ""
                if let credit = bundle.credits {
                    creditsText = filterCredits(data: credit)
                }
                
                cell.configure(
                    title: title,
                    info: info,
                    rate: rate,
                    overview: overview,
                    credits: creditsText,
                    onYouTubeTap: { [weak self] in self?.youtubeButtonTapped() },
                    onSteamedTap: { print("찜!") },
                    onShareTap: { print("share~~~") }
                )
            }
            
            return cell
            
        case .similar:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SimilarMovieCell.identifier,
                for: indexPath
            ) as! SimilarMovieCell
            
            let movie = similarMovies[indexPath.item]
            if let poster = movie.posterPath {
                let url = TMDBImageURLBuilder.shared.posterURL(path: poster, size: .w500)
                cell.configure(with: url)
            }
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               viewForSupplementaryElementOfKind kind: String,
                               at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SimilarHeaderView.identifier,
            for: indexPath
        ) as! SimilarHeaderView
        
        header.setTitle("비슷한 콘텐츠")
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let sec = Section(rawValue: section) else { return .zero }
        switch sec {
        case .detail:
            return .zero
        case .similar:
            return CGSize(width: collectionView.bounds.width, height: 44)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = Section(rawValue: indexPath.section) else { return .zero }
        
        switch section {
        case .detail:
            let width = collectionView.bounds.width - 16
            let targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
            
            let sizingCell = DetailInfoCell(frame: CGRect(x: 0, y: 0, width: width, height: 0))
            if let bundle = movieDetailBundle {
                let detail = bundle.detail
                let hour = (detail.runtime ?? 0) / 60
                let minutes = (detail.runtime ?? 0) % 60
                
                let title = detail.title ?? "-"
                let info = "\(detail.releaseDate ?? "") 개봉 \(hour)시간 \(minutes)분"
                let rate = detail.voteAverage.map { "평점 \($0)" } ?? "평점 -"
                let overview = detail.overview ?? ""
                
                var creditsText = ""
                if let credit = bundle.credits {
                    creditsText = filterCredits(data: credit)
                }
                
                sizingCell.configure(
                    title: title,
                    info: info,
                    rate: rate,
                    overview: overview,
                    credits: creditsText,
                    onYouTubeTap: {},
                    onSteamedTap: {},
                    onShareTap: {}
                )
            }
            
            let height = sizingCell.contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            ).height
            
            return CGSize(width: width, height: ceil(height))
            
        case .similar:
            let columns: CGFloat = 3
            let interItem: CGFloat = 8
            let sectionInset: CGFloat = 16
            
            let width = (collectionView.bounds.width - sectionInset - (columns - 1) * interItem) / columns
            let height = width * 1.45
            return CGSize(width: floor(width), height: floor(height))
        }
    }
}

final class DetailInfoCell: UICollectionViewCell {
    
    static let identifier = "DetailInfoCell"
    
    private var onYouTubeTap: (() -> Void)?
    private var onSteamedTap: (() -> Void)?
    private var onShareTap: (() -> Void)?
    
    private let infoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 6
        sv.alignment = .leading
        return sv
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .yFont(.label2, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .yFont(.caption1, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .yFont(.label3, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    private let youtubeButton: DSLargeButton = {
        let button = DSLargeButton(buttonStyle: .primaryApp, buttonConfig: .large)
        button.updateTitle("유튜브에서 자세히 확인하기")
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .yFont(.caption1, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let creditsLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignSystemColor.neutralGreyLight2
        label.font = .yFont(.caption1, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let bottomButtonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fill
        return stack
    }()
    
    private let steamdButton: DSIconLabelButton = {
        let button = DSIconLabelButton(style: .featured)
        button.setImage(DSImage.plus.image)
        button.setTitle("내가 찜한 리스트")
        return button
    }()
    
    private let shareButton: DSIconLabelButton = {
        let button = DSIconLabelButton(style: .featured)
        button.setImage(DSImage.share.image)
        button.setTitle("공유")
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        
        infoStackView.addArrangedSubview(movieTitleLabel)
        infoStackView.addArrangedSubview(infoLabel)
        infoStackView.addArrangedSubview(rateLabel)
        
        bottomButtonStack.addArrangedSubview(steamdButton)
        bottomButtonStack.addArrangedSubview(shareButton)
        bottomButtonStack.addArrangedSubview(UIView())
        
        contentView.addSubview(infoStackView)
        contentView.addSubview(youtubeButton)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(creditsLabel)
        contentView.addSubview(bottomButtonStack)
        
        youtubeButton.addTarget(self, action: #selector(tappedYouTube), for: .touchUpInside)
        steamdButton.addTarget(self, action: #selector(tappedSteamed), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(tappedShare), for: .touchUpInside)
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
        }
        
        youtubeButton.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(youtubeButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        
        creditsLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        
        bottomButtonStack.snp.makeConstraints { make in
            make.top.equalTo(creditsLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        [steamdButton, shareButton].forEach {
            $0.snp.makeConstraints { make in
                make.width.equalTo(contentView.snp.width).multipliedBy(0.25)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        title: String,
        info: String,
        rate: String,
        overview: String,
        credits: String,
        onYouTubeTap: @escaping () -> Void,
        onSteamedTap: @escaping () -> Void,
        onShareTap: @escaping () -> Void
    ) {
        movieTitleLabel.text = title
        infoLabel.text = info
        rateLabel.text = rate
        descriptionLabel.text = overview
        creditsLabel.text = credits
        
        self.onYouTubeTap = onYouTubeTap
        self.onSteamedTap = onSteamedTap
        self.onShareTap = onShareTap
    }
    
    @objc private func tappedYouTube() { onYouTubeTap?() }
    @objc private func tappedSteamed() { onSteamedTap?() }
    @objc private func tappedShare() { onShareTap?() }
}

final class SimilarHeaderView: UICollectionReusableView {
    static let identifier = "SimilarHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .yFont(.label2, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
}
