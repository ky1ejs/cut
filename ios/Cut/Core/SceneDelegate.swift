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
    }

    func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String) {

    }

    func scene(_ scene: UIScene, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }
}
