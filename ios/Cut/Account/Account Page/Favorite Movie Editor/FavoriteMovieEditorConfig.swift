//
//  FavoriteMovieEditorConfig.swift
//  Cut
//
//  Created by Kyle Satti on 4/23/24.
//

import Foundation

struct FavoriteMovieEditorConfig {
    static let spacing: CGFloat = 16
    static let maxItems = 5

    static func calculateItemSize(frame: CGRect) -> CGSize {
        let w: CGFloat = (frame.width - (spacing * (CGFloat(maxItems) - 1))) / CGFloat(maxItems)
        let h = w * 1.66
        return CGSize(width: w, height: h)
    }
}
