//
//  PosterCell.swift
//  Cut
//
//  Created by Kyle Satti on 4/23/24.
//

import UIKit
import Kingfisher

extension UIView: Placeholder {}

class PosterCollectionViewCell: UICollectionViewCell {
    var content: Content? {
        didSet {
            guard let content = content else { return }
            let placeholder = UIView()
            placeholder.backgroundColor = .cut_gray08
            imageView.kf.setImage(with: content.poster_url, placeholder: placeholder, options: [.transition(.fade(2))])
        }
    }
    var isWiggling = false
    private var previousDragState = UICollectionViewCell.DragState.none
    private var preDragRemoveButtonIsHidden = false
    private var didDrag = false
    var removeAction: (() -> Void)?
    private let removeButtonSize: CGFloat = 20
    let imageView = UIImageView(frame: .zero)
    let highlightedView = UIView()
    let removeButton = UIButton()

    override var isHighlighted: Bool {
        didSet {
            setIsHighlighted(isHighlighted)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        layer.cornerRadius = 2
        contentView.layer.cornerRadius = 2
        let view = UIView()
        view.backgroundColor = UIColor.clear.withAlphaComponent(0)
        backgroundView = view
        removeButton.addAction(UIAction(handler: { _ in
            self.removeAction?()
        }), for: .touchUpInside)
        [imageView, highlightedView, removeButton].forEach { contentView.addSubview($0) }
        contentView.disableAutoresizing()
        removeButton.layer.cornerRadius = removeButtonSize / 2
        removeButton.backgroundColor = Theme.current.primaryButtonBackground
        let line = UIView()
        line.backgroundColor = Theme.current.lightgray
        line.translatesAutoresizingMaskIntoConstraints = false
        line.layer.cornerRadius = 2
        removeButton.addSubview(line)
        NSLayoutConstraint.activate([
            removeButton.centerXAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 2),
            removeButton.centerYAnchor.constraint(equalTo: imageView.topAnchor, constant: 2),
            removeButton.heightAnchor.constraint(equalToConstant: removeButtonSize),
            removeButton.widthAnchor.constraint(equalToConstant: removeButtonSize),

            line.centerXAnchor.constraint(equalTo: removeButton.centerXAnchor),
            line.centerYAnchor.constraint(equalTo: removeButton.centerYAnchor),
            line.heightAnchor.constraint(equalToConstant: 2),
            line.widthAnchor.constraint(equalToConstant: removeButtonSize / 2),

            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            highlightedView.topAnchor.constraint(equalTo: contentView.topAnchor),
            highlightedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            highlightedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            highlightedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        updateRemoveButton(isHidden: true, animated: false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        content = nil
        imageView.image = nil
        removeAction = nil
    }

    override func dragStateDidChange(_ dragState: UICollectionViewCell.DragState) {
        // if the user didn't drag
        if dragState == .none &&  previousDragState == .lifting && isWiggling {
            updateRemoveButton(isHidden: false, animated: true)
        }
        previousDragState = dragState
    }

    func updateRemoveButton(isHidden: Bool, animated: Bool = true) {
        let isCurrentlyHidden = removeButton.isHidden
        guard isHidden != isCurrentlyHidden else { return }
        let initialScale: CGFloat = isCurrentlyHidden ? 0.01 : 1
        let scale: CGFloat = isHidden ? 0.01 : 1
        removeButton.transform = CGAffineTransform(scaleX: initialScale, y: initialScale)
        if isCurrentlyHidden {
            removeButton.isHidden = false
        }
        let change = {self.removeButton.transform = CGAffineTransform(scaleX: scale, y: scale)}
        let changeCompletion = { self.removeButton.isHidden = isHidden }
        if animated {
            UIView.animate(withDuration: 0.4) {
                change()
            } completion: { _ in
                changeCompletion()
            }

        } else {
            change()
            changeCompletion()
        }
    }

    private func setIsHighlighted(_ isHighlighted: Bool, animated: Bool = true) {
        let color: UIColor = isHighlighted ? .init(white: 0.5, alpha: 0.3) : .clear
        let change = {
            self.highlightedView.backgroundColor = color
        }
        let delay = isHighlighted ? 0 : 0.4
        highlightedView.layer.removeAllAnimations()
        if animated {
            UIView.animate(withDuration: 0.3, delay: delay) {
                change()
            }
        } else {
            change()
        }
    }
}

