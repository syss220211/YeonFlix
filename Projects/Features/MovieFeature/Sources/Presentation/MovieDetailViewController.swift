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
    private let favoriteButtonTapRelay = PublishRelay<Void>()
    private let viewDidLoadRelay = PublishRelay<Void>()
    
    private var movieDetailBundle: MovieDetailBundleEntity?
    private var similarMovies: [SimilarMoviesEntity] = []
    private var isFavorite: Bool = false
    weak var delegate: MovieDetailControllerDelegate?
    
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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        let originalImage = DesignSystemAsset.icClose.image
        let targetSize = CGSize(width: 14, height: 14)  // 원하는 크기
        let resizedImage = originalImage
            .resized(to: targetSize)
            .withRenderingMode(.alwaysTemplate)
        
        button.setImage(resizedImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 12.5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()

    private let backButton: UIButton = {
        let button = UIButton()
        let originalImage = DesignSystemAsset.icArrowLeft.image
        let targetSize = CGSize(width: 24, height: 24)  // 원하는 크기
        let resizedImage = originalImage
            .resized(to: targetSize)
            .withRenderingMode(.alwaysTemplate)
        
        button.setImage(resizedImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 12.5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
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

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBackButtonVisibility()
    }

    private func updateBackButtonVisibility() {
        if let navController = navigationController {
            backButton.isHidden = navController.viewControllers.count <= 1
        } else {
            backButton.isHidden = true
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(webView)
        view.addSubview(imageView)
        view.addSubview(collectionView)
        view.addSubview(loadingLabel)
        view.addSubview(closeButton)
        view.addSubview(backButton)
    }
    
    private func setupLayout() {
        webView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(210)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(210)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.top).offset(8)
            make.trailing.equalTo(webView.snp.trailing).offset(-8)
            make.width.height.equalTo(25)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.top).offset(8)
            make.leading.equalTo(webView.snp.leading).offset(8)
            make.width.height.equalTo(25)
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
        // Rx로 delegate 설정 (UICollectionViewDelegateFlowLayout 메서드들이 동작하도록)
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        let input = MovieDetailViewModel.Input(
            viewDidLoad: viewDidLoadRelay.asObservable(),
            youtubeButtonTapped: youtubeButtonTapRelay.asObservable(),
            favoriteButtonTapped: favoriteButtonTapRelay.asObservable()
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
                } else {
                    owner.showBackdropImage()
                    owner.loadBackdropImageIfNeeded()
                }

                owner.collectionView.reloadSections(IndexSet(integer: Section.detail.rawValue))
            }
            .disposed(by: disposeBag)
        
        output.similarMovies
            .drive(with: self) { owner, movies in
                owner.similarMovies = movies.filter { $0.posterPath?.isEmpty == false }
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

        output.isFavorite
            .drive(with: self) { owner, isFav in
                owner.isFavorite = isFav
                owner.collectionView.reloadSections(IndexSet(integer: Section.detail.rawValue))
            }
            .disposed(by: disposeBag)
        
        // Cell 탭했을 때 화면 이동
        collectionView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                guard let section = Section(rawValue: indexPath.section) else { return }
                
                switch section {
                case .detail:
                    break
                case .similar:
                    let movie = owner.similarMovies[indexPath.item]
                    owner.delegate?.movieDetailControllerDidSelectedSimilarMovie(movie.id)
                }
                owner.collectionView.deselectItem(at: indexPath, animated: true)
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
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension MovieDetailViewController: UICollectionViewDataSource {
    // Collection뷰에 들어가는 Section의 개수 지정
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    // 각 Section에 들어갈 item(cell)의 개수를 지정
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .detail:
            return 1
        case .similar:
            return similarMovies.count
        }
    }
     
    // (Section, item) 위치에 넣을 셀 지정
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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

                let title = detail.title
                let info = "\(detail.releaseDate ?? "") 개봉 \(hour)시간 \(minutes)분"
                let rate = detail.voteAverage.map { "평점 \($0)" } ?? "평점 -"
                let overview = detail.overview ?? ""

                var creditsText = ""
                if let credit = bundle.credits {
                    creditsText = filterCredits(data: credit)
                }

                // YouTube Trailer 존재 여부 확인
                let hasYouTubeTrailer = bundle.videos.contains { $0.type == "Trailer" && $0.site == "YouTube" }

                cell.configure(
                    title: title,
                    info: info,
                    rate: rate,
                    overview: overview,
                    credits: creditsText,
                    hasYouTubeTrailer: hasYouTubeTrailer,
                    isFavorite: self.isFavorite,
                    onYouTubeTap: { [weak self] in self?.youtubeButtonTapped() },
                    onSteamedTap: { [weak self] in self?.favoriteButtonTapRelay.accept(()) },
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
    
    // 섹션의 헤더/푸터 유무 설정
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
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
    // 섹션의 헤더 크기 지정
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let sec = Section(rawValue: section) else { return .zero }
        switch sec {
        case .detail:
            return .zero
        case .similar:
            return CGSize(width: collectionView.bounds.width, height: 44)
        }
    }
    
    
    // 셀 하나의 크기 지정
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = Section(rawValue: indexPath.section) else { return .zero }
        
        // (셀 높이를 계산하기 위해서 임시 셀을 만드는 과정)
        switch section {
        case .detail:
            let width = collectionView.bounds.width - 16
            let targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
            
            let sizingCell = DetailInfoCell(frame: CGRect(x: 0, y: 0, width: width, height: 0))
            if let bundle = movieDetailBundle {
                let detail = bundle.detail
                let hour = (detail.runtime ?? 0) / 60
                let minutes = (detail.runtime ?? 0) % 60

                let title = detail.title
                let info = "\(detail.releaseDate ?? "") 개봉 \(hour)시간 \(minutes)분"
                let rate = detail.voteAverage.map { "평점 \($0)" } ?? "평점 -"
                let overview = detail.overview ?? ""

                var creditsText = ""
                if let credit = bundle.credits {
                    creditsText = filterCredits(data: credit)
                }

                // YouTube Trailer 존재 여부 확인
                let hasYouTubeTrailer = bundle.videos.contains { $0.type == "Trailer" && $0.site == "YouTube" }

                sizingCell.configure(
                    title: title,
                    info: info,
                    rate: rate,
                    overview: overview,
                    credits: creditsText,
                    hasYouTubeTrailer: hasYouTubeTrailer,
                    isFavorite: self.isFavorite,
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

// MARK: - WebView URL 성공 여부에 따른 처리
extension MovieDetailViewController: WKNavigationDelegate {
    public func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: Error
    ) {
        showBackdropImage()
        loadBackdropImageIfNeeded()
    }

    public func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        showBackdropImage()
        loadBackdropImageIfNeeded()
    }
    
    private func showWebView() {
        webView.isHidden = false
        imageView.isHidden = true
    }

    private func showBackdropImage() {
        webView.isHidden = true
        imageView.isHidden = false
    }
    
    private func loadBackdropImageIfNeeded() {
        guard let path = movieDetailBundle?.detail.backdropPath else {
            imageView.image = nil
            imageView.backgroundColor = .darkGray
            return
        }

        let urlPath = TMDBImageURLBuilder.shared.backdropURL(path: path, size: .w780)
        guard let url = urlPath else { return }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        self.imageView.image = image
                    }
                }
            } catch {
                await MainActor.run {
                    self.imageView.backgroundColor = .darkGray
                }
            }
        }
    }
}

// MARK: - 화면이동
@MainActor
public protocol MovieDetailControllerDelegate: AnyObject {
    // 비슷한 콘텐츠으로 이동합니다.
    func movieDetailControllerDidSelectedSimilarMovie(_ movieID: Int)
}
