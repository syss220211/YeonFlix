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

        // Dirver들에서 방출하는 새로운 값들을 읽음
        Observable
            .combineLatest(
                output.nowPlaying.asObservable(),
                output.popular.asObservable(),
                output.topRated.asObservable(),
                output.upcoming.asObservable()
            )
            .observe(on: MainScheduler.instance) // 하위 작업들을 실행할 스레드 지정
            .bind(with: self) { owner, value in
                // Subscribe의 UI 바인딩 버전, 스트림에서 값이 오면 값을 받아서 UI 갱신에 연결
                let (now, pop, top, upc) = value
                owner.applySnapshot(nowPlaying: now, popular: pop, topRated: top, upcoming: upc)
                // 4개중에 하나라도 값이 바뀌는 순간 applySnapShot을 호출함
            }
            .disposed(by: disposeBag)
        
        // 로딩 상태가 바뀔때마다 UI와 연결
        output.isLoading
        // viewModel의 driver가(isLoading: Driver<Bool>) 방출하는 상태값을 VC(UI에)에서 안전하게 바인딩
            .drive(with: self) { owner, isLoading in
                if !isLoading, owner.refreshControl.isRefreshing {
                    // 로딩이 끝났을 때 사용자가 당김 새로고침중이었다면 새로고침 UI를 종료함
                    owner.refreshControl.endRefreshing()
                }
            }
            .disposed(by: disposeBag)

        output.errorMessage
        // Signal: 한번 발생하고 끝나는 이벤트를 전달하기 위한 RxCocoa 타입, Signal 전용 bind가 emit
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
