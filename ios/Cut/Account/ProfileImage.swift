//
//  ProfileImage.swift
//  Cut
//
//  Created by Kyle Satti on 3/4/24.
//

import SwiftUI

struct ProfileImage: View {
    var body: some View {
        RoundedRectangle(cornerSize: CGSize(width: 30, height: 30)).foregroundStyle(.orange).frame(width: 100, height: 100)
    }
}

#Preview {
    ProfileImage()
}
