//
//  FavoriteMoviesEditor.swift
//  Cut
//
//  Created by Kyle Satti on 4/2/24.
//

import SwiftUI

struct CoverShelf: UIViewControllerRepresentable {
    let content: [Content]
    let contentTapped: (Content) -> Void
    let isEditable: Bool
    @Binding var isEditing: Bool

    typealias UIViewControllerType = FavoriteContentEditorViewController

    func makeUIViewController(context: Context) -> FavoriteContentEditorViewController {
        FavoriteContentEditorViewController(
            content: content,
            contentTapped: contentTapped,
            isEditable: isEditable
        )
    }

    func updateUIViewController(_ uiViewController: FavoriteContentEditorViewController, context: Context) {
        uiViewController.isWobbling = isEditing
    }
}

#Preview {
    CoverShelf(content: [Mocks.content, Mocks.content, Mocks.content], contentTapped: { _ in

    }, isEditable: true, isEditing: .constant(false))
}
