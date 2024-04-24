//
//  PosterCell.swift
//  Cut
//
//  Created by Kyle Satti on 4/23/24.
//

import UIKit

class PosterCollectionViewCell: UICollectionViewCell {
    var movie: (any FavoriteMovie)? {
        didSet {
            guard let movie = movie else { return }
            imageView.kf.setImage(with: URL(string: movie.poster_url)!)
        }
    }
    var removeAction: (() -> Void)?
    let imageView = UIImageView(frame: .zero)
    lazy var removeButton = {
        let button = UIButton(type: .custom, primaryAction: UIAction(handler: { _ in
            self.removeAction?()
        }))
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        button.layer.cornerRadius = 32 / 2
        button.backgroundColor = .lightGray
        button.alpha = 0.6
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        contentView.addSubview(removeButton)
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            removeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            removeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            removeButton.heightAnchor.constraint(equalToConstant: 32),
            removeButton.widthAnchor.constraint(equalToConstant: 32)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        movie = nil
        imageView.image = nil
        removeAction = nil
    }

    override func dragStateDidChange(_ dragState: UICollectionViewCell.DragState) {
        removeButton.isHidden = dragState != .none
    }
}
