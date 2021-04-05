//
//  ListCollectionViewCell.swift
//  Wiggie
//
//  Created by Amit  Chakradhari on 04/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    static let cellReuseIdentifier = "ListCollectionViewCell"
    
    let imageView = UIImageView(frame: .zero)
    let imageLabel = UILabel(frame: .zero)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        imageLabel.textAlignment = .center
        imageLabel.numberOfLines = 1
        contentView.addSubview(imageLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1),
            imageLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            imageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
