//
//  AuthResponse.swift
//  PlatziStore
//
//  Created by mac on 7/04/25.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let refresh_token: String
}
