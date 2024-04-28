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
    var itemSize: CGSize { type(of: self).calculateItemSize(frame: collectionView!.frame) }
    var spacing: CGFloat { type(of: self).spacing }
    static let spacing: CGFloat = 10
    static let maxItems = 5

    static func calculateItemSize(frame: CGRect) -> CGSize {
        let maxItems = CGFloat(maxItems)
        let w: CGFloat = (frame.width - (spacing * (CGFloat(maxItems) - 1))) / CGFloat(maxItems)
        let h = w * 1.62
        return CGSize(width: w, height: h)
    }

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
        let items = CGFloat(collectionView.numberOfItems(inSection: 0))
        let width = items * itemSize.width + (items - 1) * spacing
        return CGSize(width: width, height: itemSize.height)
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
