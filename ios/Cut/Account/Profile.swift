//
//  Profile.swift
//  Cut
//
//  Created by Kyle Satti on 3/4/24.
//

import SwiftUI

struct Profile: View {
    enum ListState: CaseIterable, Identifiable {
        var id: Self { self }

        case rated, watchList, lists
        var title: String {
            return switch self {
            case .rated: "Rated"
            case .watchList: "Watch List"
            case .lists: "Lists"
            }
        }
    }

    @State var state = ListState.rated

    var body: some View {
        ScrollView {
            VStack {
                ProfileImage()
                Text("username")
                Button("Follow") {

                }
                HStack {
                    Text("Pinned").font(.title2).bold()
                    Spacer()
                }.padding(.top, 24)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0..<5) { _ in
                            Rectangle()
                                .frame(width: 80, height: 120)
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                        }
                    }
                }
                .scrollIndicators(.hidden)
                List {
                    ForEach(0..<8) { i in
                        Color.red
                    }
                }
            }
            .scrollClipDisabled()
        }
        .scrollClipDisabled()
        .scrollBounceBehavior(.basedOnSize)
        .padding(.horizontal, 15)
    }

    func titleFor(_ state: ListState) -> String {
        return switch state {
        case .rated: "A Rated Movie"
        case .watchList: "A Movie on the users watch list"
        case .lists: "A list that the user has created"
        }
    }
}

#Preview {
    Profile()
}
