//
//  WatchListButton.swift
//  Cut
//
//  Created by Kyle Satti on 2/22/24.
//

import SwiftUI

struct WatchListButton: View {
    let isOnWatchList: Bool
    let buttonTapped: () -> Void

    var body: some View {
        Button(action: {
            buttonTapped()
        }, label: {
            let image: UIImage = isOnWatchList ? .init(named: "check")! : .init(named: "plus")!
            Image(uiImage: image)
                .tint(isOnWatchList ? .black : .white)
        })
        .frame(width: 36, height: 36)
        .background(Circle().foregroundStyle(isOnWatchList ? Color.black : Color.sub))
    }
}

struct TodoRow_Previews: PreviewProvider {
    struct Container: View {
        @State var on: Bool = false

        var body: some View {
            WatchListButton(isOnWatchList: on) {
                on = !on
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
