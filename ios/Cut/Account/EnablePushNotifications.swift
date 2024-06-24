//
//  EnablePushNotifications.swift
//  Cut
//
//  Created by Kyle Satti on 5/21/24.
//

import SwiftUI

struct EnablePushNotifications: View {
    @State var pushNextStep = false
    @State var state = ViewState.notDetermined

    enum ViewState {
        case notDetermined, denied, auhtorized
    }

    var body: some View {
        VStack(spacing: 70) {
            if state == .auhtorized {
                ProgressView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            pushNextStep = true
                        }
                    }
            } else {
                viewContent()
                cta()
            }
        }
        .padding(.horizontal, 24)
        .navigationDestination(isPresented: $pushNextStep) {
            FindFriends()
        }
        .onAppear {
        }
        .task {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            switch settings.authorizationStatus {
            case .authorized, .ephemeral, .provisional:
                state = .auhtorized
            case .denied:
                state = .denied
            case .notDetermined:
                state = .notDetermined
            @unknown default:
                fatalError()
            }
        }
    }

    private func viewContent() -> some View {
        VStack {
            VStack(spacing: 12) {
                Text("Allow push notifications")
                    .font(.cut_title1)
                    .bold()
                Text("Get notified when someone recommends a movie or series, and when something you want to watch becomes available for streaming.")
                    .multilineTextAlignment(.center)
            }
            VStack {
                notification(
                    title: "Now Streaming",
                    body: "You can watch it on Netflix",
                    when: "Now"
                )
                notification(
                    title: "Dan shared a movie",
                    body: "Tap to see it",
                    when: "2m ago"
                )
                .scaleEffect(CGSize(width: 0.9, height: 0.9))
            }
        }
    }

    private func notification(title: String, body: String, when: String) -> some View {
        HStack(spacing: 16) {
            Image(uiImage: UIImage(named: "AppIcon")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .saturation(0)
                .mask {
                    RoundedRectangle(cornerRadius: 15)
                }
            VStack(alignment: .leading) {
                Text(title)
                    .font(.cut_title3)
                    .bold()
                Text(body)
            }
            Spacer()
        }
        .overlay {
            VStack {
                HStack {
                    Spacer()
                    Text(when)
                        .font(.footnote)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(UIColor.gray95.color)
        .mask {
            RoundedRectangle(cornerRadius: 20)
        }
    }

    private func cta() -> some View {
        VStack {
            switch state {
            case .auhtorized:
                EmptyView()
            case .notDetermined:
                    PrimaryButton("Enable notifications") {
                        UNUserNotificationCenter
                            .current()
                            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                                if granted {
                                    registerForNotifications()
                                } else {
                                    state = .denied
                                }
                            }
                    }
                    TertiaryButton("Not right now") {
                        pushNextStep = true
                }
            case .denied:
                    if let appSettings = URL(string: UIApplication.openSettingsURLString),
                       UIApplication.shared.canOpenURL(appSettings) {
                        PrimaryButton("Go to Settings") {
                            UIApplication.shared.open(appSettings)
                        }
                    }
                    TertiaryButton("Not right now") {
                        pushNextStep = true
                    }
            }
        }
    }

    private func registerForNotifications() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
        pushNextStep = true
    }
}

#Preview {
    EnablePushNotifications()
}
