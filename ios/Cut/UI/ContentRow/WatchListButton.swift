//
//  WatchListButton.swift
//  Cut
//
//  Created by Kyle Satti on 2/22/24.
//

import SwiftUI

protocol WatchListButtonProtocol: View {
    init(isOnWatchList: Bool, action: @escaping () -> Void)
}

/// Description: I experienced some issue where if this level of the view hierarchy owned both the view model and the button, state would get lost on re-renders sometimes, particularly when changing watch state on other surfaces and coming back. For some reason the diff that SwiftUI did would consider it unchanged.
struct WatchListButtonContainer<B: WatchListButtonProtocol>: View {
    @State var watchListViewModel: WatchListViewModel

    init(content: Content, index: Int? = nil) {
        watchListViewModel = WatchListViewModel(content: content, index: index)
    }

    var body: some View {
        B(isOnWatchList: watchListViewModel.isOnWatchList) {
            watchListViewModel.toggleWatchList()
        }
    }
}

typealias CircleWatchListButton = WatchListButtonContainer<_CircleWatchListButton>
struct _CircleWatchListButton: WatchListButtonProtocol {
    @Environment(\.theme) var theme
    let isOnWatchList: Bool
    let action: () -> Void

    init(isOnWatchList: Bool, action: @escaping () -> Void) {
        self.isOnWatchList = isOnWatchList
        self.action = action
    }

    var body: some View {
            Button(action: {
                action()
            }, label: {
                let image: UIImage = isOnWatchList ? .init(named: "check")! : .init(named: "plus")!
                Image(uiImage: image)
                    .tint(isOnWatchList ? .black : .white)
            })
            .buttonStyle(CircleButtonStyle())
            .background(Circle()
                .foregroundStyle(
                    isOnWatchList ? theme.primaryButtonBackground.color : theme.secondaryButtonBackground.color
                )
            )
    }
}

typealias SmallWatchListButton = WatchListButtonContainer<_SmallWatchListButton>
struct _SmallWatchListButton: WatchListButtonProtocol {
    @Environment(\.theme) var theme
    let isOnWatchList: Bool
    let action: () -> Void

    init(isOnWatchList: Bool, action: @escaping () -> Void) {
        self.isOnWatchList = isOnWatchList
        self.action = action
    }

    var body: some View {
        Button(action: {
            action()
        }, label: {
            let image: UIImage = isOnWatchList ? .init(named: "check")! : .init(named: "plus")!
            Image(uiImage: image)
                .tint(isOnWatchList ? .black : .white)
        })
        .buttonStyle(PlainButtonStyle())
        .frame(width: 36, height: 36)
        .background(Circle().foregroundStyle(isOnWatchList ? theme.primaryButtonBackground.color : theme.secondaryButtonBackground.color))
    }
}

struct TodoRow_Previews: PreviewProvider {
    struct Container: View {
        @State var on: Bool = false

        var body: some View {
            _SmallWatchListButton(isOnWatchList: on) {
                on.toggle()
            }
        }
    }

    static var previews: some View {
        Container()
    }
}

#Preview {
    TodoRow_Previews.Container()
}
