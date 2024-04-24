//
//  PlaceholderLayout.swift
//  Cut
//
//  Created by Kyle Satti on 4/23/24.
//

import UIKit

class PlaceholderLayout: OneLineCollectionViewLayout {
    override func prepare() {
        attrCache = (0..<itemCount).map(CGFloat.init).map { i in
            let x = viewWidth - (i * spacing + (i + 1) * itemSize.width)
            let frame = CGRect(origin: CGPoint(x: x, y: 0), size: itemSize)
            let attr = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: Int(i), section: 0))
            attr.frame = frame
            return attr
        }
        collectionView?.invalidateIntrinsicContentSize()
    }
}
