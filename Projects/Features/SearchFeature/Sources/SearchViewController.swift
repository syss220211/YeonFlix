//
//  SearchViewController.swift
//  SearchFeature
//
//  Created by 박서연 on 1/27/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit
import SnapKit

import RxSwift
import RxRelay
import RxCocoa

import CoreUtils
import CoreModels
import CoreCommonUI
import DesignSystem

final class SearchViewController: UIViewController {

    enum SearchMode {
        case `default`
        case searching
    }

    // MARK: - Props
    private let viewModel: SearchMovieViewModel
    private let disposeBag = DisposeBag()

    private let viewDidLoadRelay = PublishRelay<Void>()
    private let searchTextRelay = PublishRelay<String>()

    private var currentMode: SearchMode = .default {
        didSet {
            collectView.reloadData()
            labelText()
        }
    }

    private var popularMovies: [PopularMoviesEntity] = []
    private var searchResults: [MovieSearchEntity] = []
    weak var delegate: SearchMovieControllerDelegate?
    // MARK: - Views
    private let searchBar = DSSearchBar(style: .darkDefault, configuration: .default)

    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .yFont(.label2, weight: .medium)
        return label
    }()

    private lazy var collectView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(MovieListCell.self, forCellWithReuseIdentifier: MovieListCell.identifier)
        cv.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.identifier)
        return cv
    }()

    // MARK: - Init
    init(viewModel: SearchMovieViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        view.backgroundColor = .black
        
        super.viewDidLoad()
        setupUI()
        setupGestures()
        bind()
        viewDidLoadRelay.accept(())
    }

    func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(textLabel)
        view.addSubview(collectView)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(13)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        textLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        collectView.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(18)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        searchBar.blur()
    }
    func labelText() {
        switch currentMode {
        case .default:
            textLabel.text = "추천 영화"
        case .searching:
            textLabel.text = "검색 결과"
        }
    }

    // MARK: - Bind
    private func bind() {
        // SearchBar 텍스트 변경 연결
        searchBar.onTextChanged = { [weak self] text in
            self?.searchTextRelay.accept(text)
        }

        let input = SearchMovieViewModel.Input(
            viewDidLoad: viewDidLoadRelay.asObservable(),
            searchTextChanged: searchTextRelay.asObservable()
        )

        let output = viewModel.transform(input: input)

        // 검색 모드 변경
        output.searchMode
            .drive(with: self) { owner, mode in
                owner.currentMode = mode
            }
            .disposed(by: disposeBag)

        // 인기 영화 데이터
        output.popularMovies
            .drive(with: self) { owner, movies in
                owner.popularMovies = movies
                if owner.currentMode == .default {
                    owner.collectView.reloadData()
                }
            }
            .disposed(by: disposeBag)

        // 검색 결과 데이터
        output.searchResults
            .drive(with: self) { owner, results in
                owner.searchResults = results
                if owner.currentMode == .searching {
                    owner.collectView.reloadData()
                }
            }
            .disposed(by: disposeBag)

        // 로딩 상태
        output.isLoading
            .drive(with: self) { owner, isLoading in
                print(isLoading ? "🔄 Loading..." : "✅ Loaded")
            }
            .disposed(by: disposeBag)

        // 에러 메시지
        output.errorMessage
            .emit(with: self) { owner, error in
                print("❌ Error: \(error)")
            }
            .disposed(by: disposeBag)
        
        collectView.rx.itemSelected
            .subscribe(with: self) { owner, idexPath in
                let movieID: Int
                
                switch owner.currentMode {
                case .default:
                    movieID = owner.popularMovies[idexPath.item].id
                case .searching:
                    movieID = owner.searchResults[idexPath.item].id
                }
                
                owner.delegate?.searchMovieDetailControllerDidSelectedMovieResult(movieID)
            }
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentMode {
        case .default:
            return popularMovies.count
        case .searching:
            return searchResults.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch currentMode {
        case .default:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieListCell.identifier,
                for: indexPath
            ) as! MovieListCell

            let movie = popularMovies[indexPath.item]
            let backdropURL = TMDBImageURLBuilder.shared.backdropURL(path: movie.backdropPath ?? "", size: .w780)
            cell.configure(backdropURL: backdropURL, title: movie.title) {
                self.delegate?.searchMovieDetailControllerDidSelectedMovieResult(movie.id)
            }
            
            return cell

        case .searching:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SearchResultCell.identifier,
                for: indexPath
            ) as! SearchResultCell

            let movie = searchResults[indexPath.item]

            if let posterPath = movie.posterPath {
                let url = TMDBImageURLBuilder.shared.posterURL(path: posterPath, size: .w500)
                cell.configure(with: url)
            }
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch currentMode {
        case .default:
            let width = collectionView.bounds.width - 16
            return CGSize(width: width, height: 80)

        case .searching:
            let columns: CGFloat = 3
            let spacing: CGFloat = 8
            let sectionInset: CGFloat = 16

            let totalSpacing = sectionInset + (columns - 1) * spacing
            let width = (collectionView.bounds.width - totalSpacing) / columns
            let height = width * 1.45
            return CGSize(width: floor(width), height: floor(height))
        }
    }
}

// MARK: - 화면이동
@MainActor
public protocol SearchMovieControllerDelegate: AnyObject {
    // 검색 영화 상세 화면으로 이동합니다.
    func searchMovieDetailControllerDidSelectedMovieResult(_ movieID: Int)
}

@MainActor
public final class SearchMovieViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
        let searchTextChanged: Observable<String>
    }

    struct Output {
        let popularMovies: Driver<[PopularMoviesEntity]>
        let searchResults: Driver<[MovieSearchEntity]>
        let isLoading: Driver<Bool>
        let errorMessage: Signal<String>
        let searchMode: Driver<SearchViewController.SearchMode>
    }

    private let useCase: SearchUseCase
    private let disposeBag = DisposeBag()

    private let popularMoviesRelay = BehaviorRelay<[PopularMoviesEntity]>(value: [])
    private let searchResultsRelay = BehaviorRelay<[MovieSearchEntity]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorMessageRelay = PublishRelay<String>()
    private let searchModeRelay = BehaviorRelay<SearchViewController.SearchMode>(value: .default)
    
    public init(useCase: SearchUseCase) {
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {
        // viewDidLoad 시 인기 영화 로드
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                owner.fetchPopularMovies(page: 1)
            }
            .disposed(by: disposeBag)

        // 검색어 변경 처리 (디바운싱 0.5초)
        input.searchTextChanged
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, query in
                if query.isEmpty {
                    owner.searchModeRelay.accept(.default)
                    owner.searchResultsRelay.accept([])
                } else {
                    owner.searchModeRelay.accept(.searching)
                    owner.fetchSearchMovies(query: query, page: 1)
                }
            }
            .disposed(by: disposeBag)

        return Output(
            popularMovies: popularMoviesRelay.asDriver(),
            searchResults: searchResultsRelay.asDriver(),
            isLoading: isLoadingRelay.asDriver(),
            errorMessage: errorMessageRelay.asSignal(),
            searchMode: searchModeRelay.asDriver()
        )
    }

    private func fetchPopularMovies(page: Int) {
        isLoadingRelay.accept(true)

        Task { [useCase] in
            do {
                let response = try await useCase.fetchPopularMovies(page: page)
                popularMoviesRelay.accept(response.results)
            } catch {
                errorMessageRelay.accept(error.localizedDescription)
            }
            isLoadingRelay.accept(false)
        }
    }

    private func fetchSearchMovies(query: String, page: Int) {
        isLoadingRelay.accept(true)

        Task { [useCase] in
            do {
                let response = try await useCase.fetchSearchMovies(query: query, page: page)
                searchResultsRelay.accept(response.results)
            } catch {
                errorMessageRelay.accept(error.localizedDescription)
            }
            isLoadingRelay.accept(false)
        }
    }
}
