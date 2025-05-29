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
    case products = "https://api.escuelajs.co/api/v1/products"
    case categories = "https://api.escuelajs.co/api/v1/categories"
    
    var description: String { return rawValue }
}
