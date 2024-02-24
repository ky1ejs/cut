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
            .placeholder { Color(.red) }
            .loadDiskFileSynchronously()
            .cacheOriginalImage()
            .fade(duration: 0.25)
            .onProgress { receivedSize, totalSize in  }
            .onFailure { error in }
            .resizable()
            .aspectRatio(contentMode: .fit)


    }
}

#Preview {
    URLImage(url: URL(string: "https://image.tmdb.org/t/p/ymswR4vhemmgq8m7bNbOdiPohOU.jpg")!)
}
