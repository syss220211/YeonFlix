//
//  SimilarHeaderView.swift
//  MovieFeature
//
//  Created by 박서연 on 1/26/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

final class SimilarHeaderView: UICollectionReusableView {
    static let identifier = "SimilarHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .yFont(.label2, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
}
