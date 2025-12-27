//
//  HomeFeatureTest.swift
//  Manifests
//
//  Created by 박서연 on 11/26/25.
//

import UIKit

import CoreCommonUI
import CoreNetwork
import CoreSecurity
import DesignSystem

public final class HomeViewController: UIViewController {

    private let useCase: HomeUseCase
    private let saveTokenButton = DSButton(style: .primary, title: "Save API Token to Keychain")
    private let testButton = DSButton(style: .primary, title: "Fetch Now Playing Movies")
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        label.text = "Press 'Save API Token' first, then fetch movies"
        return label
    }()
    
    public init(useCase: HomeUseCase) {
        self.useCase = useCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = DesignSystemColor.background
        view.addSubview(saveTokenButton)
        view.addSubview(testButton)
        view.addSubview(resultLabel)
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

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(testButton.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    private func setupActions() {
        saveTokenButton.addTarget(self, action: #selector(saveTokenTapped), for: .touchUpInside)
        testButton.addTarget(self, action: #selector(fetchMoviesTapped), for: .touchUpInside)
    }

    @objc private func saveTokenTapped() {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "TMDB_ACCESS_TOKEN") as? String else {
            resultLabel.text = "❌ Error: TMDB_ACCESS_TOKEN not found in Info.plist"
            return
        }

        let keyStore = KeychainAPIKeyStore()

        do {
            try keyStore.save(token)
            resultLabel.text = "✅ API Token saved to Keychain successfully!"
        } catch {
            resultLabel.text = "❌ Failed to save token:\n\(error.localizedDescription)"
        }
    }

    @objc private func fetchMoviesTapped() {
        resultLabel.text = "Loading..."

        let useCase = self.useCase

        Task { [weak self] in
            guard let self else { return }

            do {
                let entity = try await useCase.fetchNowPlayingMovies(page: 1)

                await MainActor.run {
                    let movieCount = entity.results.count
                    let firstMovie = entity.results.first

                    var resultText = "✅ Success!\n\n"
                    resultText += "Total Results: \(entity.totalResults)\n"
                    resultText += "Total Pages: \(entity.totalPages)\n"
                    resultText += "Current Page: \(entity.page)\n"
                    resultText += "Movies Loaded: \(movieCount)\n\n"

                    if let movie = firstMovie {
                        resultText += "First Movie:\n"
                        resultText += "Title: \(movie.title)\n"
                        resultText += "Release: \(movie.releaseDate)"
                    }

                    self.resultLabel.text = resultText
                }
            } catch {
                await MainActor.run {
                    self.resultLabel.text = "❌ Error:\n\(error.localizedDescription)"
                }
            }
        }
    }
}
