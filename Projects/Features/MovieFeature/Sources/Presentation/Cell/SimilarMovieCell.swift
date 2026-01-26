//
//  SimilarMovieCell.swift
//  MovieFeature
//
//  Created by 박서연 on 1/25/26.
//  Copyright © 2026 linda. All rights reserved.
//

import UIKit

final class SimilarMovieCell: UICollectionViewCell {
    static let identifier = "SimilarMovieCell"
    
    private let posterImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
        contentView.backgroundColor = .clear
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        
        contentView.addSubview(posterImageView)
        
        posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(1.45)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with posterURL: URL?) {
        guard let url = posterURL else { return }
        
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
