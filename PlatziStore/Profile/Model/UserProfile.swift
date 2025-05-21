//
//  UserProfile.swift
//  PlatziStore
//
//  Created by mac on 25/04/25.
//

import Foundation

struct UserProfile: Decodable {
    let id: Int
    let email: String
    let name: String
    let password: String
    let role: String
    let avatar: String
}
