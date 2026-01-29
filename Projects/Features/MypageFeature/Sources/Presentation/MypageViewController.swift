//
//  MypageViewController.swift
//  MypageFeature
//
//  Created by 박서연 on 1/29/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

import CoreUtils
import CoreModels
import DesignSystem

final class MypageViewController: UIViewController, UITableViewDelegate {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewDidLoadRelay = PublishRelay<Void>()
    
    private var favoriteMovies: [FavoriteMovieEntity] = []
    private let viewModel: MypageViewModel
    private let disposeBag = DisposeBag()
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavigationbar()
        setupUI()
        bind()
        viewDidLoadRelay.accept(())
    }
    
    private func setupNavigationbar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white

        let titleLabel = UILabel()
        titleLabel.text = "마이페이지"
        titleLabel.textColor = .white
        titleLabel.font = .yFont(.label2, weight: .bold)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(rightButtonTapped)
        )
    }
    
    @objc func rightButtonTapped() {
        print("rightButtonTapped")
    }
    
    init(viewModel: MypageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    func bind() {
        let input = MypageViewModel.Input(viewDidLoad: viewDidLoadRelay.asObservable())
        let output = viewModel.transform(input: input)
        
        output.favortieMovies
            .drive(with: self) { owner, movies in
                owner.favoriteMovies = movies
                owner.tableView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    func setupUI() {
        view.backgroundColor = .black
        view.addSubview(tableView)

        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyPageMovieCell.self, forCellReuseIdentifier: MyPageMovieCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 180

        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension MypageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyPageMovieCell.identifier, for: indexPath) as! MyPageMovieCell
        
        let movie = favoriteMovies[indexPath.item]
        cell.configure(
            title: movie.title,
            description: movie.movieDescription,
            poster: TMDBImageURLBuilder.shared.posterURL(path: movie.posterPath, size: .w500)
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteMovies.count
    }
}
