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

struct ProfileUserResponse {
    private let name: String
    private let email: String
    private let password: String
    private let avatar: String
    private let address: String
    private let currentCountry: String
    private let wallet: Int
    private let vehicle: Vehicle
}

struct Vehicle {
    let numeberOfWheels: Int
    let type: String
    let maxVelocity: Int
    let typeOfGas: String
    let doors: Int
    let owner: UserModel
}
