//
//  EnablePushNotifications.swift
//  Cut
//
//  Created by Kyle Satti on 5/21/24.
//

import SwiftUI

struct EnablePushNotifications: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
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
            Spacer()
            VStack {
                PrimaryButton("Enable notifications") {

                }
                TertiaryButton("Not right now") {

                }
            }
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 24)
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
}

#Preview {
    EnablePushNotifications()
}
