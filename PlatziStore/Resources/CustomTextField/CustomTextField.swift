//
//  CustomTextField.swift
//  PlatziStore
//
//  Created by mac on 28/04/25.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(Strings.empty.rawValue, text: $text, prompt: Text(placeholder).foregroundColor(.gray))
            } else {
                TextField(Strings.empty.rawValue, text: $text, prompt: Text(placeholder).foregroundColor(.gray))
            }
        }
        .padding()
        .frame(width: 300, height: 50)
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 0.5))
        .foregroundColor(.white)
    }
}
