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
            if let _ = session.sessionId {
                Root()
            } else {
                DeviceRegister()
            }
        }
    }
}
