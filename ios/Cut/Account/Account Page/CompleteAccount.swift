//
//  CompleteAccount.swift
//  Cut
//
//  Created by Kyle Satti on 3/14/24.
//

import SwiftUI

struct CompleteAccount: View {
    let account: CutGraphQL.GetAccountQuery.Data.Account.AsCompleteAccount
    @State var state = ListState.rated

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

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        Text(account.name).font(.cut_title3.bold()).foregroundColor(.white)
                        Text(account.username).font(.cut_footnote).foregroundColor(.white)
                        Text(account.bio ?? "").font(.cut_footnote).foregroundColor(.white)
                        Text(account.url ?? "").font(.cut_footnote).foregroundColor(.white)
                        Spacer()
                    }
                    Spacer()
                    ProfileImage()
                }
                .padding(.bottom, 24)
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).foregroundStyle(.white)
                        Text("Edit profile").foregroundStyle(.black)
                    }.frame(height: 40)
                })
                .padding(.bottom, 24)
                Picker(selection: $state) {
                    ForEach(ListState.allCases) { s in
                        Text(s.title).tag(s)
                    }
                } label: {
                    Text("Ignored")
                }
                .pickerStyle(.segmented)
                .preferredColorScheme(.dark)
            }
            .scrollBounceBehavior(.basedOnSize)
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    let json = """
    {
        "__typename": "Query",
        "account": {
          "__typename": "CompleteAccount",
          "username": "kylejs",
          "name": "Kyle Satti",
          "bio": "Co-founder of Cut",
          "url": "https://kylejs.dev",
          "id": "72686e5d-025f-46ef-b78d-a1511fd01383",
          "followerCount": 0,
          "followingCount": 0,
          "watchList": [],
          "followers": [],
          "following": []
        }
      }
    """
    let jsonObject = try! JSONSerialization.jsonObject(with: json.data(using: .utf8)!) as! [String: AnyHashable]
    return CompleteAccount(account: try! CutGraphQL.GetAccountQuery.Data(data: jsonObject).account.asCompleteAccount!)
}
