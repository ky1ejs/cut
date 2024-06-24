//
//  CutApp.swift
//  Cut
//
//  Created by Kyle Satti on 2/3/24.
//

import SwiftUI

@main
struct CutApp: App {
    @ObservedObject private var session = SessionManager.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ZStack {
                if session.isOnboarding {
                    NavigationStack {
                        WelcomeView()
                    }
                    .onOpenURL(perform: { url in
                        DeepLinkManager.shared.open(url)
                    })
                    .environment(\.onboardingCompletion) {
                        SessionManager.shared.isOnboarding = false
                    }
                } else {
                    Root()
                        .onOpenURL(perform: { url in
                            DeepLinkManager.shared.open(url)
                        })
                }
            }
            .animation(.easeInOut, value: session.isOnboarding)
        }
    }
}
