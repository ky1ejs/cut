//
//  IncompleteAccount.swift
//  Cut
//
//  Created by Kyle Satti on 3/14/24.
//

import SwiftUI



struct IncompleteAccount: View {
    @ObservedObject var viewModel: AccountViewModel
    @State private var isSettingsPresented = false

    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                Button {
                    isSettingsPresented = true
                } label: {
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .tint(.gray)
                        .padding(.horizontal, 18)
                }
            }
            ProfileImage(url: nil)
                .padding(.bottom, 16)
            Text("Complete your account to keep your data safe and follow friends").font(.title2).multilineTextAlignment(.center)
            Spacer(minLength: 48)
            PrimaryButton(text: "Complete my account") {
                viewModel.isCompleteAccountPresented = true
            }
            SecondaryButton(text: "Why do I need an account?") {
                viewModel.isAccountExplainerPresented = true
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .sheet(isPresented: $isSettingsPresented, content: {
            NavigationStack {
                Settings(isPresented: $isSettingsPresented)
            }
        })
    }
}

