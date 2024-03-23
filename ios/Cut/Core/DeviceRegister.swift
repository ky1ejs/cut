//
//  DeviceRegister.swift
//  Cut
//
//  Created by Kyle Satti on 2/10/24.
//

import SwiftUI

struct DeviceRegister: View {
    var body: some View {
        ProgressView()
            .task {
                register()
            }
    }

    private func register() {
        SessionManager.shared.signUp { result in }
    }
}

#Preview {
    DeviceRegister()
}
