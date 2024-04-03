//
//  URLImage.swift
//  Cut
//
//  Created by Kyle Satti on 2/22/24.
//

import SwiftUI
import Kingfisher


struct URLImage: View {
    let url: URL

    var body: some View {
        KFImage.url(url)
            .cacheOriginalImage()
            .placeholder { Color.gray }
            .fade(duration: 0.25)
            .resizable()
            .aspectRatio(contentMode: .fit)


    }
}

#Preview {
    URLImage(url: URL(string: "https://image.tmdb.org/t/p/original/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg")!)
}
