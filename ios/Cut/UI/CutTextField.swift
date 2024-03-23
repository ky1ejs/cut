//
//  CutTextField.swift
//  Cut
//
//  Created by Kyle Satti on 3/23/24.
//

import SwiftUI

struct CutTextField<T>: View where T: View {
    @Binding var text: String
    let label: String
    let isSecure: Bool
    let accessory: (() -> T)?

    init(text: Binding<String>, label: String, isSecure: Bool = false, accessory: (() -> T)? = nil) {
        _text = text
        self.label = label
        self.isSecure = isSecure
        self.accessory = accessory
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(label).font(.cut_footnote)
            HStack {
                if isSecure {
                    SecureField(text: $text) { placeholder }
                } else {
                    TextField(text: $text) { placeholder }
                }
                accessory?()
            }
        }
        .textFieldStyle(CutTextFieldStyle())
    }

    private var placeholder: some View {
        Text(label.lowercased())
    }
}

extension CutTextField where T == EmptyView {
    init(text: Binding<String>, label: String, isSecure: Bool = false) {
        _text = text
        self.label = label
        accessory = nil
        self.isSecure = isSecure
    }
}

struct CutTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(.gray, lineWidth: 0.3))
            .foregroundColor(.black)
        }
}

#Preview {
    CompleteAccountForm(emailVerificationToken: "")
}
