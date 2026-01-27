//
//  MovieListCell.swift
//  SearchFeature
//
//  Created by 박서연 on 1/27/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

import DesignSystem

final class MovieListCell: UICollectionViewCell {
    static let identifier = "MovieSearchCell"
    
    private var onPlusTap: (()->Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .yFont(.caption1, weight: .bold)
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        let originalImage = DesignSystemAsset.icPlus.image
        let targetSize = CGSize(width: 18, height: 18)
        let resizedImage = originalImage
            .resized(to: targetSize)
            .withRenderingMode(.alwaysTemplate)
        
        button.setImage(resizedImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 12.5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .black
        
        setupUI()
    }
    
    func setupUI() {
        contentView.addSubview(cellStackView)

        cellStackView.addArrangedSubview(backdropImageView)
        cellStackView.addArrangedSubview(titleLabel)
        cellStackView.addArrangedSubview(plusButton)

        cellStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backdropImageView.snp.makeConstraints { make in
            make.height.equalTo(contentView.snp.height).offset(-16)
            make.width.equalTo(backdropImageView.snp.height).multipliedBy(16.0 / 9.0)
        }

        plusButton.snp.makeConstraints { make in
            make.width.height.equalTo(25)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        backdropURL: URL?,
        title: String,
        onPlusTap: @escaping ()->Void
    ) {
        self.titleLabel.text = title
        self.onPlusTap = onPlusTap

        self.backdropImageView.image = nil
        self.backdropImageView.backgroundColor = .darkGray
        guard let url = backdropURL else { return }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        self.backdropImageView.image = image
                    }
                }
            } catch {
                await MainActor.run {
                    self.backdropImageView.backgroundColor = .darkGray
                }
            }
        }
    }
    
    @objc func plusButtonTapped() { self.onPlusTap?() }
}
