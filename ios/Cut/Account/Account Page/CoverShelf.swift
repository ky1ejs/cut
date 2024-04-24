//
//  CoverShelf.swift
//  Cut
//
//  Created by Kyle Satti on 3/26/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct CoverShelf: View {
    let movies: [CutGraphQL.FavoriteMovieFragment]
    let editable: Bool
    @State private var presentEdit = false

    var body: some View {
        VStack {
            if editable {
                HStack {
                    Spacer()
                    Button("Edit") {
                        presentEdit = true
                    }
                }
            }
            HStack {
                ForEach(movies, id: \.id) { m in
                    URLImage(m.poster_url)
                }
                if editable {
                    if movies.count < 5 {
                        ForEach(0..<5 - movies.count, id: \.self) { _ in
                            Button {
                                presentEdit = true
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray, lineWidth: 1.0)
                                        .background(.clear)
                                        .aspectRatio(0.66, contentMode: .fit)
                                    Image(systemName: "plus")
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $presentEdit, content: {
            FavoriteMovieEditor(movies: movies, isPresented: $presentEdit)
                .ignoresSafeArea()
        })
    }
}


#Preview {
    let url = URL(string: Mocks.movie.poster_url)!
    return CoverShelf(movies: [Mocks.favoriteMovie], editable: true)
        .padding(.horizontal, 12)
        .frame(maxHeight: .infinity)
}
