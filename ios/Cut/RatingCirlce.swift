//
//  RatingCirlce.swift
//  Cut
//
//  Created by Kyle Satti on 2/24/24.
//

// from https://sarunw.com/posts/swiftui-circular-progress-bar/

import SwiftUI

struct RatingCirlce: View {
    let rating: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.pink.opacity(0.2),
                    lineWidth: 8
                )
            Circle()
                .trim(from: 0, to: rating)
                .stroke(
                    Color.pink,
                    style: StrokeStyle(
                        lineWidth: 8,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                // 1
                .animation(.easeOut, value: rating)
            Text("\(Int(rating * 100))%")
                .font(.system(size: 14, weight: .bold, design: .rounded))

        }.frame(maxHeight: 45)
    }
}

#Preview {
    RatingCirlce(rating: 0.68)
}
