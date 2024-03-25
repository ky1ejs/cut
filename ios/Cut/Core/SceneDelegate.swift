//
//  SceneDelegate.swift
//  Cut
//
//  Created by Kyle Satti on 3/11/24.
//

import SwiftUI

class SceneDelegate: NSObject, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let context = URLContexts.first else {
            return
        }
        DeepLinkManager.shared.open(context.url)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print(userActivity)
    }

    func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String) {

    }

    func scene(_ scene: UIScene, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                  UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                UNUserNotificationCenter.current()
                    .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                        guard granted else { return }
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
            }
          }
    }
}
