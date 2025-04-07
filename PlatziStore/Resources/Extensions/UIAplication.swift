//
//  UIAplication.swift
//  PlatziStore
//
//  Created by mac on 7/04/25.
//

import SwiftUI

extension UIApplication {
    func hideKeyboard() {
        guard let window = connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .filter({ $0.isKeyWindow })
            .first else { return }
        window.endEditing(true)
    }
}
