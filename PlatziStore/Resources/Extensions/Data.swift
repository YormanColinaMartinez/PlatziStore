//
//  Data.swift
//  PlatziStore
//
//  Created by mac on 12/05/25.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
