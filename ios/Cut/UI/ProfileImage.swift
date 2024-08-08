//
//  ProfileImage.swift
//  Cut
//
//  Created by Kyle Satti on 3/4/24.
//

import SwiftUI
import Kingfisher

struct ProfileImage: View {
    let state: ViewState

    enum ViewState {
        case loaded(URL?)
        case uploading(UIImage)
    }

    init(state: ViewState) {
        self.state = state
    }

    init(url: URL?) {
        state = .loaded(url)
    }

    var body: some View {
        ZStack {
            switch state {
            case .loaded(let url):
                KFImage(url)
                    .resizable()
                    .placeholder { Image.placeHolderAvatar }
                    .aspectRatio(contentMode: .fit)
            case .uploading(let image):
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Color.gray.opacity(0.6)
                ProgressView()
            }
        }
        .mask {
            RoundedRectangle(cornerRadius: 20)
        }
        .frame(width: 100, height: 100)
    }
}

#Preview {
    ProfileImage(url: nil)
}

#Preview {
    ProfileImage(url: URL(string: "https://ucarecdn.com/cdc6a0e6-6a48-42dc-8295-0013e2fc768b/-/resize/500x500/-/format/jpeg/profile")!)
}
