//
//  PosterGrid.swift
//  Cut
//
//  Created by Kyle Satti on 3/31/24.
//

import SwiftUI

struct PosterGrid: View {
    let content: [Content]
    @State private var presentedContent: Content?

    var body: some View {
        if content.count > 0 {
                LazyVGrid(
                    columns: Array(
                        repeating: .init(.flexible(minimum: 100), spacing: 0),
                        count: 3
                    ),
                    spacing: 0
                ) {
                    ForEach(content, id: \.id) { content in
                        Button {
                            presentedContent = content
                        } label: {
                            PosterCell(url: content.poster_url)
                        }
                    }
                }
            .sheet(item: $presentedContent) { c in
                ContentDetailView(content: c)
            }
        } else {
            Text("nothing to see here")
                .font(.cut_title2)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    PosterGrid(
        content: (0..<15).map { _ in  Mocks.content }
    )
}
