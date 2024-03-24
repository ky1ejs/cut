//
//  ProfileHeader.swift
//  Cut
//
//  Created by Kyle Satti on 3/18/24.
//

import SwiftUI

struct ProfileHeader: View {
    let profile: CutGraphQL.ProfileInterfaceFragment
    @Environment(\.openURL) private var openURL

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(profile.name).font(.cut_title3.bold())
                Text(profile.username).font(.cut_footnote)
                Text(profile.bio ?? "").font(.cut_footnote)
                Button {
                    if let url = URL(string: profile.url ?? "") {
                        openURL(url)
                    }
                } label: {
                    Text(profile.url ?? "").font(.cut_footnote)
                }

                Spacer()
            }
            Spacer()
            ProfileImage()
        }
    }
}

#Preview {
    VStack {
        ProfileHeader(profile: Mocks.profileInterface)
        Spacer()
    }
}
