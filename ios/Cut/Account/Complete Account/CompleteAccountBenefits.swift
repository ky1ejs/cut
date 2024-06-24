//
//  CompleteAccountBenefits.swift
//  Cut
//
//  Created by Kyle Satti on 2/27/24.
//

import SwiftUI
import MarkdownUI

struct CompleteAccountBenefits: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 4) {
                Text("🎬")
                    .font(.system(size: 80))
                    .padding(.top, 48)
                Text("Why complete your Cut account?")
                    .font(.cut_title1)
                    .multilineTextAlignment(.center)
                Text("Until your complete your account, you're unable to:")
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)
                Markdown("""
                - Follow your friends and see what they want to watch or what they've rated
                - Sign into your cut account on another device or when you get a new one
                """)
                NavigationLink(destination: {
                    EmailForm()
                }, label: {
                    PrimaryButton("Complete") {}
                }).padding(.top, 16)
                TertiaryButton("Maybe Later"){
                    dismiss()
                }
                Spacer()
            }
            .padding(24)
        }.toolbar(.hidden, for: .navigationBar)
    }

}

#Preview {
    CompleteAccountBenefits()
}
