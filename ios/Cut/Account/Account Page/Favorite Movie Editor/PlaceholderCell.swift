//
//  PlaceholderCell.swift
//  Cut
//
//  Created by Kyle Satti on 4/23/24.
//

import UIKit

class PlaceholderCollectionViewCell: UICollectionViewCell {
    private let xbar = UIView()
    private let ybar = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 1
        setIsHighlighted(false, animated: false)
        [xbar, ybar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
            NSLayoutConstraint.activate([
                $0.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                $0.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ])
        }
        NSLayoutConstraint.activate([
            xbar.widthAnchor.constraint(equalToConstant: 12),
            xbar.heightAnchor.constraint(equalToConstant: 1),
            ybar.widthAnchor.constraint(equalToConstant: 1),
            ybar.heightAnchor.constraint(equalToConstant: 12),
        ])
    }

    override var isHighlighted: Bool {
        didSet {
            setIsHighlighted(isHighlighted)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setIsHighlighted(_ isHighlighted: Bool, animated: Bool = true) {
        let t = Theme.current
        let color = isHighlighted ? t.subtitle : t.lightgray
        let change = {
            self.contentView.layer.borderColor = color.cgColor
            self.xbar.backgroundColor = color
            self.ybar.backgroundColor = color
        }
        let delay = isHighlighted ? 0.4 : 0
        if animated {
            UIView.animate(withDuration: 0.5, delay: delay) {
                change()
            }
        } else {
            change()
        }
    }
}
