//
//  CompleteAccountBenefits.swift
//  Cut
//
//  Created by Kyle Satti on 2/27/24.
//

import SwiftUI
import MarkdownUI

struct CompleteAccountBenefits: View {
    @Binding var isPresented: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                Color.cutOrange.ignoresSafeArea()
                VStack(alignment: .center, spacing: 4) {
                    Text("🎬")
                        .font(.system(size: 80))
                        .padding(.top, 48)
                    Text("Why complete your Cut account?")
                        .font(.cut_title1)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                    Text("Until your complete your account, you're unable to:")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.top, 16)
                    Markdown("""
                - Follow your friends and see what they want to watch or what they've rated
                - Sign into your cut account on another device or when you get a new one
                """)

                    NavigationLink(destination: {
                        InitiateEmailConfirm()
                    }, label: {
                        Text("Complete")
                            .bold()
                            .padding(12)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 6, height: 6)))
                            .foregroundColor(.black)

                    }).padding(.top, 16)
                    Button(action: {
                        isPresented = false
                    }, label: {
                        Text("Maybe later")
                    })
                    Spacer()
                }
                .padding(24)
                .border(.red)
            }
        }
        .toolbar(.hidden, for: .navigationBar)

    }
}

struct CompleteAccountBenefits_Previews: PreviewProvider {
    struct Container: View {
        @State var on: Bool = false

        var body: some View {
            CompleteAccountBenefits(isPresented: $on)
        }
    }

    static var previews: some View {
        Container()
    }
}

#Preview {
    CompleteAccountBenefits_Previews.Container()
}
