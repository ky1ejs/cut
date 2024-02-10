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

    var body: some Scene {
        WindowGroup {
            if let _ = session.sessionId {
                ContentView()
            } else {
                DeviceRegister()
            }
        }
    }
}
