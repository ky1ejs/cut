//
//  ImageStack.swift
//  Cut
//
//  Created by Kyle Satti on 2/22/24.
//

import SwiftUI

struct ImageStack: View {
    let urls: [String]
    private let spacing: CGFloat = 5
    private let size: CGFloat = 20

    var body: some View {
        HStack(spacing: -spacing) {
            ForEach(0..<urls.count, id: \.self) { i in
                if i < urls.count - 1 {
                    circle()
                        .foregroundColor(.red)
                        .mask(MoonMask(amount: spacing)
                        .fill(style: FillStyle(eoFill: true)))
                } else {
                    circle()
                        .foregroundColor(.red)
                }
            }
        }
        .frame(maxHeight: spacing * 4)
    }

    private func circle() -> some View {
        Circle()
            .frame(width: size, height: size)
    }
}

struct MoonMask: Shape {
    let amount: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)
        path.addPath(Circle().path(in: rect)
            .offsetBy(dx: amount * 2.4, dy: 0))
        return path
    }
}

#Preview {
    VStack {
        ImageStack(urls: ["test", "rest"])
    }
}
