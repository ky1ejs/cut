//
//  IncompleteAccount.swift
//  Cut
//
//  Created by Kyle Satti on 3/14/24.
//

import SwiftUI



struct IncompleteAccount: View {
    @ObservedObject var viewModel: AccountViewModel

    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                NavigationLink {
                    Settings()
                } label: {
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .tint(.gray)
                        .padding(.horizontal, 18)
                }
            }
            ProfileImage()
                .padding(.bottom, 16)
            Text("Complete your account to keep your data safe and follow friends").font(.title2).multilineTextAlignment(.center)
            Spacer(minLength: 48)
            Button(action: {
                viewModel.isCompleteAccountPresented = true
            }) { Text("Complete my account").foregroundStyle(.white).font(.title3) }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.orange)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
            Button(action: {
                viewModel.isAccountExplainerPresented = true
            }) { Text("Why do I need an account?").foregroundStyle(.gray).font(.title3) }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
        }
    }
}

