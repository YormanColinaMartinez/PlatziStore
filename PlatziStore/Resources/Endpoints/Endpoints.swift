//
//  Endpoints.swift
//  PlatziStore
//
//  Created by mac on 23/05/25.
//

import Foundation

enum Endpoints: String {
    case baseUrl = "https://api.escuelajs.co/api/v1"
    case fetchUserProfile = "https://api.escuelajs.co/api/v1/auth/profile"
    case updateProfile = "https://api.escuelajs.co/api/v1/users/"
    
    var description: String { return rawValue }
}
