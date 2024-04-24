//
//  OneLineCollectionViewLayout.swift
//  Cut
//
//  Created by Kyle Satti on 4/23/24.
//

import UIKit

class OneLineCollectionViewLayout: UICollectionViewLayout {
    var attrCache = [UICollectionViewLayoutAttributes]()
    var viewWidth: CGFloat { collectionView?.frame.width ?? 0 }
    var itemCount: Int { collectionView?.numberOfItems(inSection: 0) ?? 0 }
    let spacing = FavoriteMovieEditorConfig.spacing
    var itemSize: CGSize { FavoriteMovieEditorConfig.calculateItemSize(frame: collectionView!.frame) }

    override func prepare() {
        attrCache = (0..<itemCount).map(CGFloat.init).map { i in
            let x: CGFloat = i * spacing + i * itemSize.width
            let frame = CGRect(origin: CGPoint(x: x, y: 0), size: itemSize)
            let attr = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: Int(i), section: 0))
            attr.frame = frame
            return attr
        }
        collectionView?.invalidateIntrinsicContentSize()
        collectionView?.superview?.invalidateIntrinsicContentSize()
    }

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }
        return CGSize(width: collectionView.frame.size.width, height: itemSize.height)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrCache
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attrCache[indexPath.item]
    }

    override func invalidateLayout() {
        super.invalidateLayout()
        attrCache = []
    }
}
