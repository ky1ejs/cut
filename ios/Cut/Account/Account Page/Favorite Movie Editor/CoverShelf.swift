//
//  FavoriteMoviesEditor.swift
//  Cut
//
//  Created by Kyle Satti on 4/2/24.
//

import SwiftUI

struct CoverShelf: UIViewControllerRepresentable {
    let movies: [Movie]
    let movieTapped: (Movie) -> Void
    let isEditable: Bool
    @Binding var isEditing: Bool

    typealias UIViewControllerType = FavoriteMovieEditorViewController

    func makeUIViewController(context: Context) -> FavoriteMovieEditorViewController {
        FavoriteMovieEditorViewController(
            movies: movies,
            movieTapped: movieTapped,
            isEditable: isEditable
        )
    }

    func updateUIViewController(_ uiViewController: FavoriteMovieEditorViewController, context: Context) {
        uiViewController.isWobbling = isEditing
    }
}

#Preview {
    CoverShelf(movies: [Mocks.movie, Mocks.movie, Mocks.movie], movieTapped: { _ in

    }, isEditable: true, isEditing: .constant(false))
}
