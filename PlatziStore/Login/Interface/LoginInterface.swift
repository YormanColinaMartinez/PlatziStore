//
//  LoginInterface.swift
//  PlatziStore
//
//  Created by mac on 2/05/25.
//

import Foundation

protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> String?
    func register(name: String, email: String, password: String) async throws -> String?
}
