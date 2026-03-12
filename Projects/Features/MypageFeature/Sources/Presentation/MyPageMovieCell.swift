//
//  MyPageMovieCell.swift
//  MypageFeature
//
//  Created by 박서연 on 1/29/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import RxRelay

import SnapKit
import DesignSystem

public final class MyPageMovieCell: UITableViewCell {
    static let identifier: String = "MyPageMovieCell"
    
    let detailButtonTapped = PublishRelay<Void>()
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .black
        contentView.backgroundColor = .black
        selectionStyle = .none

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        detailButton.rx.tap
            .bind(to: detailButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private let posterImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .yFont(.caption1, weight: .bold)
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .yFont(.caption2, weight: .medium)
        label.textColor = DesignSystemColor.neutralGreyLight2
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let detailButton: UIButton = {
        let button = UIButton()
        button.setTitle("상세로 이동", for: .normal)
        button.setTitleColor(DesignSystemColor.neutralGreyLight2, for: .normal)
        button.titleLabel?.font = .yFont(.caption1, weight: .bold)
        return button
    }()
    
    func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(detailButton)

        let posterWidth = UIScreen.main.bounds.width * 0.25
        let posterHeight = posterWidth * 1.5

        posterImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(posterWidth)
            make.height.equalTo(posterHeight).priority(.high) // UITableView에서 계산한 height에 값 양보
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(10)
            make.top.equalTo(posterImageView.snp.top)
            make.trailing.equalTo(detailButton.snp.leading).offset(-8)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.trailing.equalTo(detailButton.snp.leading).offset(-8)
            make.bottom.lessThanOrEqualTo(posterImageView.snp.bottom)
        }

        detailButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalTo(posterImageView)
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    public func configure(title: String, description: String, poster: URL?) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        
        self.posterImageView.image = nil
        guard let url = poster else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        self.posterImageView.image = image
                    }
                }
            } catch {
                await MainActor.run {
                    self.posterImageView.backgroundColor = .darkGray
                }
            }
        }
    }
}
