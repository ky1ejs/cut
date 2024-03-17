//
//  UsernameAvailabilityIndicator.swift
//  Cut
//
//  Created by Kyle Satti on 2/28/24.
//

import SwiftUI

struct UsernameAvailabilityIndicator: View {
    let state: State

    enum State {
        case empty, loading, available, unavailable, error
    }

    var body: some View {
        switch state {
        case .empty, .loading: Circle().foregroundStyle(.gray).frame(width: 14, height: 14)
        case .error: Text("⚠️")
        case .available: Circle().foregroundStyle(.green).frame(width: 14, height: 14)
        case .unavailable: Circle().foregroundStyle(.red).frame(width: 14, height: 14)
        }
    }
}

#Preview {
    UsernameAvailabilityIndicator(state: .empty)
}

#Preview {
    UsernameAvailabilityIndicator(state: .loading)
}

#Preview {
    UsernameAvailabilityIndicator(state: .available)
}

#Preview {
    UsernameAvailabilityIndicator(state: .unavailable)
}

#Preview {
    UsernameAvailabilityIndicator(state: .error)
}
