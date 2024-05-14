//
//  PosterImage.swift
//  Cut
//
//  Created by Kyle Satti on 5/11/24.
//

import SwiftUI
import Kingfisher

struct PosterImage: View {
    let url: URL?
    private let width: CGFloat = 100

    var body: some View {
        KFImage(url)
            .cacheOriginalImage()
            .placeholder { Color.gray }
            .fade(duration: 0.25)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: width * 1.64)
            .mask {
                RoundedRectangle(cornerRadius: 10)
            }
    }
}
