//
//  ProfileImage.swift
//  Cut
//
//  Created by Kyle Satti on 3/4/24.
//

import SwiftUI

struct ProfileImage: View {
    @State private var width: CGFloat = 0
    var body: some View {
        RoundedRectangle(cornerRadius: width * 0.3)
            .background(content: {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            width = proxy.size.width
                        }
                }
            })
            .foregroundStyle(.orange)
            .frame(maxWidth: 100, maxHeight: 100)
    }
}

#Preview {
    ProfileImage()
}
