//
//  UsernameAvailabilityIndicator.swift
//  Cut
//
//  Created by Kyle Satti on 2/28/24.
//

import SwiftUI

struct UsernameAvailabilityIndicator: View {
    let state: ViewState

    @State private var animationColor = Color.gray
    @State private var loadingOnScreen = false

    enum ViewState {
        case empty, loading, available, unavailable, error

        var color: Color {
            switch self {
            case .empty: return .gray
            case .error: return .red
            case .available: return .green
            case .unavailable: return .red
            case .loading: return .gray
            }
        }
    }

    var body: some View {
        if state == .loading {
            StateCircle.foregroundStyle(animationColor)
                .animation(.linear(duration: 0.5).repeatForever(), value: animationColor)
                .onAppear(perform: {
                    animationColor = .orange
                })
        } else {
            StateCircle.foregroundStyle(state.color)
                .animation(.easeIn, value: state)
        }
    }

    private var StateCircle: some View {
        Circle().frame(width: 14, height: 14)
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

private struct StateTest: View {
    @State var isLoading = false

    var body: some View {
        UsernameAvailabilityIndicator(state: isLoading ? .loading : .unavailable)
        TertiaryButton("Toggle") {
            isLoading.toggle()
        }
    }
}

#Preview {
    StateTest()
}
