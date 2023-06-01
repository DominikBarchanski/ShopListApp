//
//  CustomTextField.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var error: Binding<String>?
    var placeholder: String
    var imageName: String
    var isPassword: Bool = false

    init(text: Binding<String>, error: Binding<String>? = nil, placeholder: String, imageName: String, isPassword: Bool = false) {
        self._text = text
        self.error = error
        self.placeholder = placeholder
        self.imageName = imageName
        self.isPassword = isPassword
    }

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.gray)
            if isPassword {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
        .overlay(Group {
            if let error = error, !error.wrappedValue.isEmpty {
                Text(error.wrappedValue)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding([.leading, .trailing])
            }
        }, alignment: .bottom)
    }
}

