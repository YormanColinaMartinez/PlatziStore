//
//  LoginInterface.swift
//  PlatziStore
//
//  Created by mac on 7/04/25.
//

import Foundation

protocol LoginServiceInterface: AnyObject {
    func fetchUsersAsync(url: String) async throws -> [UserModel]
    func searchUser(email: String) async throws -> UserModel
}
