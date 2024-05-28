//
//  WelcomeView.swift
//  Cut
//
//  Created by Kyle Satti on 5/19/24.
//

import SwiftUI

struct WelcomeView: View {
    @State var presentOnboarding = false
    @State var pushEmail = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    ForEach(0..<3, id: \.self) { i in
                        VStack {
                            ForEach(0..<3, id: \.self) { v in
                                Image("content_\((i*3) + (v+1))")
                                    .resizable()
                                    .aspectRatio(0.6, contentMode: .fit)
                                    .mask {
                                        RoundedRectangle(cornerRadius: 14)
                                    }.overlay {
                                        if v == 2 {
                                            VStack {
                                                Spacer()
                                                Image("friend\(i+1)")
                                                    .frame(width: 70, height: 70)
                                                    .foregroundColor(.red)
                                                    .offset(y: 20)
                                                    .offset(x: offset(i))
                                            }
                                        }
                                    }
                            }
                            .offset(y: i == 1 ? -60 : 0)
                        }
                        .containerRelativeFrame(.horizontal) { proxy, _ in
                            proxy / 3 - 20
                        }
                    }
                }
                .padding(.top, 8)
                Text("Cut")
                    .font(.cut_largeTitle)
                    .bold()
                Text("Watchlists and friends recommendations, all in one place.")
                    .font(.cut_title1)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(UIColor.gray20.color)
                    .padding(.bottom, 24)
                PrimaryButton("Get Started") {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    presentOnboarding = true
                }
                .padding(.horizontal, 12)
                .sheet(isPresented: $presentOnboarding) {
                    VStack(spacing: 24) {
                        Text("Get Started")
                            .font(.cut_largeTitle)
                        Text("Create a free account to make watchlists, connect with your friends, and more.")
                            .multilineTextAlignment(.center)
                        VStack {
                            PrimaryButton("Continue with email") {
                                pushEmail = true
                                presentOnboarding = false
                            }
                            HStack {
                                Button("") {

                                }
                                .buttonStyle(SecondaryButtonStyle())
                                Button("G") {

                                }
                                .buttonStyle(SecondaryButtonStyle())
                            }
                        }
                        Button("Continue without an account") {

                        }

                    }
                    .padding(.horizontal, 12)
                    .presentationDetents([.fraction(0.45)])
                    .presentationBackgroundInteraction(.disabled)
                }
            }
            .ignoresSafeArea()
            .navigationDestination(isPresented: $pushEmail) {
                EmailForm()
            }
            if presentOnboarding {
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                    .ignoresSafeArea()
            }
        }
        .animation(.linear, value: presentOnboarding)
    }

    private func offset(_ i: Int) -> CGFloat {
        let offset: CGFloat = 24
        switch i {
        case 0: return offset
        case 2: return -offset
        default: return 0
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
