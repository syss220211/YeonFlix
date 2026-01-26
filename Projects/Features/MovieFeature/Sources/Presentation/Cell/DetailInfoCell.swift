//
//  DetailInfoCell.swift
//  MovieFeature
//
//  Created by 박서연 on 1/26/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

import SnapKit

import CoreCommonUI
import DesignSystem

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
        hasYouTubeTrailer: Bool,
        onYouTubeTap: @escaping () -> Void,
        onSteamedTap: @escaping () -> Void,
        onShareTap: @escaping () -> Void
    ) {
        movieTitleLabel.text = title
        infoLabel.text = info
        rateLabel.text = rate
        descriptionLabel.text = overview
        creditsLabel.text = credits

        // YouTube 버튼 표시 여부 설정
        youtubeButton.isHidden = !hasYouTubeTrailer

        // YouTube 버튼이 숨겨지면 descriptionLabel의 top constraint를 infoStackView 기준으로 변경
        descriptionLabel.snp.remakeConstraints { make in
            if hasYouTubeTrailer {
                make.top.equalTo(youtubeButton.snp.bottom).offset(10)
            } else {
                make.top.equalTo(infoStackView.snp.bottom).offset(10)
            }
            make.leading.trailing.equalToSuperview()
        }

        self.onYouTubeTap = onYouTubeTap
        self.onSteamedTap = onSteamedTap
        self.onShareTap = onShareTap
    }
    
    @objc private func tappedYouTube() { onYouTubeTap?() }
    @objc private func tappedSteamed() { onSteamedTap?() }
    @objc private func tappedShare() { onShareTap?() }
}
