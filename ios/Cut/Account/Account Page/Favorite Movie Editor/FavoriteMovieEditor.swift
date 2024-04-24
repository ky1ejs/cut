//
//  FavoriteMoviesEditor.swift
//  Cut
//
//  Created by Kyle Satti on 4/2/24.
//

import SwiftUI

struct FavoriteMovieEditor: UIViewControllerRepresentable {
    let movies: [CutGraphQL.FavoriteMovieFragment]
    @Binding var isPresented: Bool

    typealias UIViewControllerType = FavoriteMovieEditorViewController

    func makeUIViewController(context: Context) -> FavoriteMovieEditorViewController {
        FavoriteMovieEditorViewController(movies: movies) {
            isPresented = false
        }
    }

    func updateUIViewController(_ uiViewController: FavoriteMovieEditorViewController, context: Context) {

    }
}


#Preview {
    FavoriteMovieEditor(movies: [Mocks.favoriteMovie, Mocks.favoriteMovie, Mocks.favoriteMovie], isPresented: Binding.constant(true))
}
