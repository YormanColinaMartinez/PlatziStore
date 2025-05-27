//
//  Colors.swift
//  PlatziStore
//
//  Created by mac on 27/05/25.
//

import SwiftUI

enum Colors: String {
    case mainColorApp = "mainColorApp"
    case platziGreenColor = "platziGreenColor"
    
    var color: Color {
        Color(rawValue, bundle: nil)
    }
}
