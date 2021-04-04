//
//  GridCollectionViewCell.swift
//  Wiggie
//
//  Created by Amit  Chakradhari on 04/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    static let cellReuseIdentifier = "GridCollectionViewCell"
    
    let imageView = UIImageView(frame: .zero)
    let imageLabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .orange
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        contentView.addSubview(imageView)
        
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        imageLabel.textAlignment = .center
        imageLabel.numberOfLines = 1
        contentView.addSubview(imageLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            imageLabel.heightAnchor.constraint(equalToConstant: 24),
            imageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
