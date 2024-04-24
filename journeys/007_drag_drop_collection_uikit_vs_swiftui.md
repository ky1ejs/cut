# Drag & Drop Reordering: UIKit vs SwiftUI

## TL;DR; Use UICollectionView
UIKit wins because with SwiftUI you need to create a background view that takes up the whole of the screen in order to update state on drop, otherwise your collection view, that takes up only a portion of the screen, does not know that a drop happened. This would look like [this answer on Stack Overflow](https://stackoverflow.com/a/63438481/3053366):

```swift
  struct DropOutsideDelegate: DropDelegate { 
      @Binding var current: GridData?  
          
      func performDrop(info: DropInfo) -> Bool {
          current = nil
          return true
      }
  }

  struct DemoDragRelocateView: View {
      ...

      var body: some View {
          ScrollView {
              ...
          }
          .onDrop(of: [UTType.text], delegate: DropOutsideDelegate(current: $dragging))
      }
  }
```

## Other reasons to use UIKit
The Drag/Drop API on UICollectionView also allows you to repond with drops of other data (e.g. from outside your app) like so:
```swift
  // UICollectionViewDropDelegate 
  func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
      guard collectionView.hasActiveDrag else {
          return UICollectionViewDropProposal(operation: .forbidden)
      }
      return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
  }
```
I didn't see a way to do this in SwiftUI.

## Progress Made
Here was my drag drop implementation for SwiftUI that has the problem with dropping outside of frame:

```swift
//
//  CoverShelf.swift
//  Cut
//
//  Created by Kyle Satti on 3/26/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct CoverShelf: View {
    @State var movies: [CutGraphQL.FavoriteMovieFragment]
    @State private var dragging: CutGraphQL.FavoriteMovieFragment?
    @State var presentEdit = false

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Edit") {
                    presentEdit = true
                }
            }
            HStack {
                ForEach(movies, id: \.id) { m in
                    URLImage(m.poster_url)
                        .onDrag({
                            dragging = m
                            return NSItemProvider(object: "Deez nuts" as NSString)
                        })
                        .overlay(dragging?.id == m.id ? Color.white.opacity(0.8) : Color.clear)
                        .onDrop(of: [UTType.text], delegate: DragRelocateDelegate(item: m, listData: $movies, current: $dragging, onComplete: {
                            AuthorizedApolloClient.shared.client.perform(mutation: CutGraphQL.UpdateAccountMutation(params: CutGraphQL.UpdateAccountInput(favoriteMovies: GraphQLNullable.some(movies.map { $0.id }))))
                        }))
                }.animation(.default, value: movies)
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
                        .draggable("Test", preview: { Text("Source View") })
                    }
                }
            }
        }
        .sheet(isPresented: $presentEdit, content: {
            FavoriteMoviesEditor(movies: movies, isPresented: $presentEdit)
                .ignoresSafeArea()
        })
    }
}

struct DragRelocateDelegate<T: Equatable>: DropDelegate {
    let item: T
    @Binding var listData: [T]
    @Binding var current: T?
    let onComplete: () -> Void

    func dropEntered(info: DropInfo) {
        if item != current {
            let from = listData.firstIndex(of: current!)!
            let to = listData.firstIndex(of: item)!
            if listData[to] != current {
                listData.move(fromOffsets: IndexSet(integer: from),
                    toOffset: to > from ? to + 1 : to)
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        current = nil
        onComplete()
        return true
    }
}

#Preview {
    let url = URL(string: Mocks.movie.poster_url)!
    return CoverShelf(movies: [Mocks.favoriteMovie])
        .padding(.horizontal, 12)
        .frame(maxHeight: .infinity)
}

```