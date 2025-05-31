//
//  SessionManager.swift
//  PlatziStore
//
//  Created by mac on 26/05/25.
//

import Foundation

class SessionManager: ObservableObject {
    private var keychainManager: KeychainManager = KeychainManager.shared
    @Published var isLoggedIn: Bool = false
    
    init() {
        self.isLoggedIn = !getToken().isEmpty
    }
    
    func saveToken(accessToken: String) {
        keychainManager.save(accessToken, forKey: "authToken")
        isLoggedIn = true
    }
    
    func deleteToken() {
        keychainManager.delete(forKey: "authToken")
        isLoggedIn = false
    }
    
    func getToken() -> String {
        return (keychainManager.get(forKey: "authToken")) ?? .empty
    }
    
    func isTokenValid() -> Bool {
        let token = getToken()
        return token.isEmpty
    }
}
