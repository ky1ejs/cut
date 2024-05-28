//
//  OtpCodeTextField.swift
//  Cut
//
//  Created by Kyle Satti on 5/26/24.
//

import SwiftUI
import Combine


struct OtpCodeTextField: View {
    @Binding var text: String
    @State var digits = [Character]()
    @FocusState var textFieldFocused: Bool
    let digitCount: Int
    let onComplete: () -> Void

    var body: some View {
        ZStack {
            TextField(text: $text) {

            }
            .frame(width: 1, height: 1)
            .focused($textFieldFocused)
            .accentColor(.clear)
            .foregroundColor(.clear)
            .onChange(of: text) { _, newValue in
                if newValue.count > digitCount {
                    text = String(newValue.prefix(digitCount))
                }
                digits = Array(text)
                if text.count == digitCount {
                    onComplete()
                    textFieldFocused = false
                }
            }

            HStack {
                ForEach(0..<digits.count, id: \.self) { i in
                    DigitContent(text: String(digits[i]), focused: i == digitCount - 1  && textFieldFocused)
                        .onTapGesture(perform: {
                            textFieldFocused = true
                        })
                }
                if digits.count < digitCount {
                    ForEach(0..<(digitCount - digits.count), id: \.self) { i in
                        DigitContent(text: "", focused: i == 0  && textFieldFocused)
                            .onTapGesture(perform: {
                                textFieldFocused = true
                            })
                    }
                }
            }
        }
    }
}

struct DigitContent: View {
    @Environment(\.theme) var theme
    let text: String
    let focused: Bool
    var body: some View {
        Text(text)
            .frame(width: 22, height: 44)
            .font(.cut_title2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(theme.grayBackground.color)
            .mask {
                RoundedRectangle(cornerRadius: 5)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(focused ? .black : .clear)
            }
    }
}

#Preview {
    OtpCodeTextField(text: .constant(""), digitCount: 4) { }
}
