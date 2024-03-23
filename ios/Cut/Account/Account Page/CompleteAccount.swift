//
//  CompleteAccount.swift
//  Cut
//
//  Created by Kyle Satti on 3/14/24.
//

import SwiftUI

struct CompleteAccount: View {
    let account: CutGraphQL.CompleteAccountFragment
    @State var state = ListState.rated
    @State private var editAccount = false
    @State private var findContacts = false
    
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
            ScrollView {
                HStack {
                    Spacer()
                    NavigationLink {
                        Settings()
                    } label: {
                        Image(systemName: "gear")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .tint(.gray)
                            .padding(.bottom, 18)
                    }
                }
                ProfileHeader(profile: account.fragments.profileFragment)
                .padding(.bottom, 24)
                PrimaryButton(text: "Edit Profile") { editAccount = true }
                PrimaryButton(text: "Find Friends") { findContacts = true }
                    .padding(.bottom, 24)
                Picker(selection: $state) {
                    ForEach(ListState.allCases) { s in
                        Text(s.title).tag(s)
                    }
                } label: {
                    Text("Ignored")
                }
                .pickerStyle(.segmented)
            }
            .scrollBounceBehavior(.basedOnSize)
            .padding(.horizontal, 24)
            .sheet(isPresented: $editAccount, content: {
                EditAccount(user: account) {
                    editAccount = false
                }
            })
            .sheet(isPresented: $findContacts, content: {
                FindFriendsViaContacts()
            })
    }
}

#Preview {
    CompleteAccount(account: Mocks.completeAccount)
}
