//
//  PlaceholderCell.swift
//  Cut
//
//  Created by Kyle Satti on 4/23/24.
//

import UIKit

class PlaceholderCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 5
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 2
        let plus = UIImageView(image: UIImage(systemName: "cross"))
        plus.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(plus)
        plus.tintColor = .lightGray
        NSLayoutConstraint.activate([
            plus.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            plus.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            plus.widthAnchor.constraint(equalToConstant: 32),
            plus.heightAnchor.constraint(equalToConstant: 32),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
