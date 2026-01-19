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

final class HomeViewController: UIViewController {

    // MARK: - Section / Item
    enum Section: Int, CaseIterable, Hashable {
        case nowPlaying
        case popular
        case topRated
        case upcoming

        var title: String {
            switch self {
            case .nowPlaying: return "상영 중"
            case .popular: return "인기 영화"
            case .topRated: return "평점 높은 영화"
            case .upcoming: return "개봉 예정"
            }
        }
    }

    enum Item: Hashable {
        case poster(HomePosterItem)
    }

    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        cv.backgroundColor = .black
        cv.alwaysBounceVertical = true
        return cv
    }()

    private let refreshControl = UIRefreshControl()

    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    private var dataSource: DataSource!
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        configureDataSource()
        bind()
        applyInitialSnapshot()
    }

    // MARK: - Setup
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.refreshControl = refreshControl
    }

    // MARK: - Layout
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else { return nil }

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 0, leading: 6, bottom: 0, trailing: 6)

            let groupHeight: CGFloat = (section == .nowPlaying) ? 240 : 210
            let groupWidth: CGFloat = (section == .nowPlaying) ? 0.42 : 0.34

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(groupWidth),
                heightDimension: .absolute(groupHeight)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            sectionLayout.interGroupSpacing = 8
            sectionLayout.contentInsets = .init(top: 8, leading: 16, bottom: 24, trailing: 16)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            sectionLayout.boundarySupplementaryItems = [header]

            return sectionLayout
        }
    }

    // MARK: - DataSource
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<PosterCell, Item> { cell, _, item in
            guard case let .poster(posterItem) = item else { return }
            let url = posterItem.posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500\($0)") }
            cell.configure(posterURL: url)
        }

        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<HomeSectionHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] header, _, indexPath in
            guard let self,
                  let section = Section(rawValue: indexPath.section) else { return }
            header.configure(title: section.title)
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }

    private func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func applySnapshot(
        nowPlaying: [HomePosterItem],
        popular: [HomePosterItem],
        topRated: [HomePosterItem],
        upcoming: [HomePosterItem]
    ) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)

        snapshot.appendItems(nowPlaying.map { .poster($0) }, toSection: .nowPlaying)
        snapshot.appendItems(popular.map { .poster($0) }, toSection: .popular)
        snapshot.appendItems(topRated.map { .poster($0) }, toSection: .topRated)
        snapshot.appendItems(upcoming.map { .poster($0) }, toSection: .upcoming)

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - Bind
    private func bind() {
        let input = HomeViewModel.Input(
            viewDidLoad: Observable.just(()),
            refresh: refreshControl.rx.controlEvent(.valueChanged).asObservable()
        )

        let output = viewModel.transform(input: input)

        Observable
            .combineLatest(
                output.nowPlaying.asObservable(),
                output.popular.asObservable(),
                output.topRated.asObservable(),
                output.upcoming.asObservable()
            )
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, value in
                let (now, pop, top, upc) = value
                owner.applySnapshot(nowPlaying: now, popular: pop, topRated: top, upcoming: upc)
            }
            .disposed(by: disposeBag)

        output.isLoading
            .drive(with: self) { owner, isLoading in
                if !isLoading, owner.refreshControl.isRefreshing {
                    owner.refreshControl.endRefreshing()
                }
            }
            .disposed(by: disposeBag)

        output.errorMessage
            .emit(with: self) { owner, message in
                let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                owner.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

final class PosterCell: UICollectionViewCell {
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true

        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    func configure(posterURL: URL?) {
        guard let url = posterURL else {
            imageView.backgroundColor = .darkGray
            print("⚠️ No poster URL")
            return
        }

        print("🖼️ Loading image from: \(url)")
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        self.imageView.image = image
                        print("✅ Image loaded successfully")
                    }
                } else {
                    print("❌ Failed to create image from data")
                }
            } catch {
                print("❌ Image load error: \(error)")
                await MainActor.run {
                    self.imageView.backgroundColor = .darkGray
                }
            }
        }
    }
}

final class HomeSectionHeaderView: UICollectionReusableView {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 18)

        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(title: String) {
        titleLabel.text = title
    }
}

//public final class HomeViewController: UIViewController {
//    private let viewModel: HomeViewModel
//    
//    public init(viewModel: HomeViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//}


//public final class HomeViewController: UIViewController {
//
//    private let viewModel: HomeViewModel
//    public let disposeBag = DisposeBag()
//
//    private let saveTokenButton = DSButton(style: .primary, title: "Save API Token to Keychain")
//    private let testButton = DSButton(style: .primary, title: "Fetch Now Playing Movies")
//    private let navigationButton = DSButton(style: .primary, title: "Movie! Detail")
//
//    private let customButtonPrimaryApp = DSLargeButton(buttonStyle: .primaryOnboarding, buttonConfig: .large)
//    private let customButtonPrimaryOnboarding = DSLargeButton(buttonStyle: .primaryApp, buttonConfig: .medium)
//    private let customButtonSecondaryApp = DSLargeButton(buttonStyle: .secondaryApp, buttonConfig: .small)
//
//    @objc
//    func secondaryTapped() {
//        print("isItPossibileTapp?")
//    }
//    
//    private let resultLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.textAlignment = .center
//        label.font = .systemFont(ofSize: 14)
//        label.textColor = .label
//        return label
//    }()
//    
//    public init(viewModel: HomeViewModel) {
//        self.viewModel = viewModel
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
//        bindViewModel()
//    }
//
//    private func setupUI() {
//        view.backgroundColor = DesignSystemColor.background
//        view.addSubview(saveTokenButton)
//        view.addSubview(testButton)
//        view.addSubview(navigationButton)
//        view.addSubview(customButtonPrimaryApp)
//        view.addSubview(customButtonPrimaryOnboarding)
//        view.addSubview(customButtonSecondaryApp)
//        view.addSubview(resultLabel)
//
//        customButtonPrimaryApp.updateTitle("Primary App Style")
//        customButtonPrimaryOnboarding.updateTitle("Primary Onboarding Style")
//        customButtonSecondaryApp.updateTitle("Secondary App Style")
//        customButtonSecondaryApp.updateImage(DSImage.search.image)
//        customButtonSecondaryApp.addTarget(self, action: #selector(secondaryTapped), for: .touchUpInside)
//    }
//
//    private func setupLayout() {
//        saveTokenButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview().offset(-150)
//            make.width.equalTo(250)
//            make.height.equalTo(52)
//        }
//
//        testButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(saveTokenButton.snp.bottom).offset(20)
//            make.width.equalTo(250)
//            make.height.equalTo(52)
//        }
//
//        navigationButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(testButton.snp.bottom).offset(20)
//            make.width.equalTo(250)
//            make.height.equalTo(52)
//        }
//
//        customButtonPrimaryApp.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(navigationButton.snp.bottom).offset(20)
//            make.leading.equalToSuperview().offset(20)
//            make.trailing.equalToSuperview().offset(-20)
//        }
//
//        customButtonPrimaryOnboarding.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(customButtonPrimaryApp.snp.bottom).offset(16)
//            make.leading.equalToSuperview().offset(20)
//            make.trailing.equalToSuperview().offset(-20)
//        }
//
//        customButtonSecondaryApp.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(customButtonPrimaryOnboarding.snp.bottom).offset(16)
//            make.leading.equalToSuperview().offset(20)
//            make.trailing.equalToSuperview().offset(-20)
//        }
//
//        resultLabel.snp.makeConstraints { make in
//            make.top.equalTo(customButtonSecondaryApp.snp.bottom).offset(40)
//            make.leading.equalToSuperview().offset(20)
//            make.trailing.equalToSuperview().offset(-20)
//        }
//    }
//
//    private func bindViewModel() {
//        let input = HomeViewModel.Input(
//            saveTokenTapped: saveTokenButton.rx.tap.asObservable(),
//            fetchMoviesTapped: testButton.rx.tap.asObservable(),
//            movieDetailTapped: navigationButton.rx.tap.map { 12345 }
//        )
//
//        let output = viewModel.transform(input: input)
//
//        output.resultText
//            .drive(resultLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        output.isLoading
//            .drive(onNext: { [weak self] isLoading in
//                self?.testButton.isEnabled = !isLoading
//                self?.saveTokenButton.isEnabled = !isLoading
//            })
//            .disposed(by: disposeBag)
//
//        output.isMoviesFetched
//            .drive(onNext: { [weak self] isFetched in
//                self?.customButtonPrimaryApp.isEnabled = isFetched
//                self?.customButtonPrimaryOnboarding.isEnabled = isFetched
//                self?.customButtonSecondaryApp.isEnabled = isFetched
//            })
//            .disposed(by: disposeBag)
//    }
//}
