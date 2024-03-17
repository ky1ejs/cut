//
//  CutButton.swift
//  Cut
//
//  Created by Kyle Satti on 3/2/24.
//

import SwiftUI

struct CutButton: View {
    let action: () -> ()
    let text: String
    let state: ButtonState

    enum ButtonState {
        case loading, notLoading
    }

    var body: some View {
        Button(action: action, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10).foregroundStyle(.white)
                if state == .loading {
                    ProgressView()
                } else {
                    Text(text).bold().foregroundStyle(.black)
                }
            }.frame(height: 44)
        }).disabled(state == .loading)
    }
}

#Preview {
    ZStack {
        Color.cutOrange
        HStack {
            CutButton(action: {}, text: "Test", state: .loading)
        }.padding(.horizontal, 30)
    }
    .ignoresSafeArea()
}

#Preview {
    ZStack {
        Color.cutOrange
        HStack {
            CutButton(action: {}, text: "Test", state: .notLoading)
        }.padding(.horizontal, 30)
    }
    .ignoresSafeArea()
}
