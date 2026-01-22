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

import CoreModels

import RxSwift
import RxRelay
import RxCocoa

@MainActor
public final class MovieDetailViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
    }

    struct Output {
        let movieDetail: Driver<MovieDetailBundleEntity>
        let isLoading: Driver<Bool>
        let errorMessage: Signal<String>
    }

    private let useCase: MovieDetailUseCase
    private let movieID: Int
    private let disposeBag = DisposeBag()

    private let movieDetailRelay = BehaviorRelay<MovieDetailBundleEntity?>(value: nil)
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorMessageRelay = PublishRelay<String>()

    public init(movieID: Int, useCase: MovieDetailUseCase) {
        self.movieID = movieID
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                owner.fetchMovieDetail()
            }
            .disposed(by: disposeBag)

        return Output(
            movieDetail: movieDetailRelay
                .compactMap { $0 }
                .asDriver(onErrorDriveWith: .empty()),
            isLoading: isLoadingRelay.asDriver(),
            errorMessage: errorMessageRelay.asSignal()
        )
    }

    private func fetchMovieDetail() {
        isLoadingRelay.accept(true)

        Task { [movieID, useCase] in
            do {
                let bundle = try await useCase.fetchMovieDetail(movieId: movieID)
                print("✅ BUNDLE: \(bundle)")
                movieDetailRelay.accept(bundle)
            } catch {
                errorMessageRelay.accept(error.localizedDescription)
            }
            isLoadingRelay.accept(false)
        }
    }
//    @MainActor
//    private func fetchMovieDetail() -> Single<MovieDetailBundleEntity> {
//        isLoadingRelay.accept(true)
//        
//        return Single.create { [useCase] single in
//            let task = Task {
//                print("🎬 [MovieDetail] API 호출 시작 - Movie ID: \(self.movieID)")
//
//                do {
//                    let movieDetailBundle = try await useCase.fetchMovieDetail(movieId: self.movieID)
//                    let detail = movieDetailBundle.detail
//
//                    print("✅ [MovieDetail] API 호출 성공!")
//                    print("📌 제목: \(detail.title)")
//                    print("📌 원제: \(detail.originalTitle ?? "N/A")")
//                    print("📌 개봉일: \(detail.releaseDate ?? "N/A")")
//                    print("📌 평점: \(detail.voteAverage ?? 0.0) / 10")
//                    print("📌 러닝타임: \(detail.runtime ?? 0)분")
//                    print("📌 장르: \(detail.genres.map { $0.name }.joined(separator: ", "))")
//                    print("📌 줄거리: \(detail.overview ?? "N/A")")
//                    if let tagline = detail.tagline, !tagline.isEmpty {
//                        print("📌 태그라인: \(tagline)")
//                    }
//                    print("📌 예산: $\(detail.budget ?? 0)")
//                    print("📌 수익: $\(detail.revenue ?? 0)")
//                    print("📌 언어: \(detail.spokenLanguages.compactMap { $0.name }.joined(separator: ", "))")
//                    print("📌 제작국가: \(detail.productionCountries.compactMap { $0.name }.joined(separator: ", "))")
//                    print("📌 비디오 개수: \(movieDetailBundle.videos.count)")
//                    if let credits = movieDetailBundle.credits {
//                        print("📌 출연진 수: \(credits.cast.count)")
//                        print("📌 제작진 수: \(credits.crew.count)")
//                    }
//
//                    self.movieDetailRelay.accept(movieDetailBundle)
//                    self.isLoadingRelay.accept(false)
//                    single(.success(movieDetailBundle))
//                } catch {
//                    print("❌ [MovieDetail] API 호출 실패: \(error)")
//                    self.errorMessageRelay.accept(error.localizedDescription)
//                    self.isLoadingRelay.accept(false)
//                }
//            }
//            
//            return Disposables.create { task.cancel() }
//        }
//    }
}


//public final class MovieDetailViewController: UIViewController {
//
//    private let movieID: Int
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Movie Detail"
//        label.font = .systemFont(ofSize: 24, weight: .bold)
//        label.textAlignment = .center
//        label.textColor = .label
//        return label
//    }()
//
//    private let movieIDLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 18, weight: .medium)
//        label.textAlignment = .center
//        label.textColor = .label
//        label.numberOfLines = 0
//        return label
//    }()
//
//    private let descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.text = "This is a test movie detail screen.\nMovie ID is displayed below:"
//        label.font = .systemFont(ofSize: 14)
//        label.textAlignment = .center
//        label.textColor = .secondaryLabel
//        label.numberOfLines = 0
//        return label
//    }()
//
//    public init(movieID: Int) {
//        self.movieID = movieID
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupLayout()
//        configureData()
//    }
//
//    private func setupUI() {
//        view.backgroundColor = DesignSystemColor.background
//        navigationItem.title = "Movie Detail"
//
//        view.addSubview(titleLabel)
//        view.addSubview(descriptionLabel)
//        view.addSubview(movieIDLabel)
//    }
//
//    private func setupLayout() {
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
//            make.leading.equalToSuperview().offset(20)
//            make.trailing.equalToSuperview().offset(-20)
//        }
//
//        descriptionLabel.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(20)
//            make.leading.equalToSuperview().offset(20)
//            make.trailing.equalToSuperview().offset(-20)
//        }
//
//        movieIDLabel.snp.makeConstraints { make in
//            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
//            make.leading.equalToSuperview().offset(20)
//            make.trailing.equalToSuperview().offset(-20)
//        }
//    }
//
//    private func configureData() {
//        movieIDLabel.text = "Movie ID: \(movieID)"
//    }
//}
