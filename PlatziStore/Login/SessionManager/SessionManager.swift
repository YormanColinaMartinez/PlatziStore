//
//  SessionManager.swift
//  PlatziStore
//
//  Created by mac on 26/05/25.
//

import Foundation

class SessionManager: ObservableObject {
    
    //MARK: - Properties -
    private var keychainManager: KeychainManager = KeychainManager.shared
    @Published var isLoggedIn: Bool = false
    
    //MARK: - Initializers -
    init() {
        self.isLoggedIn = hasValidSession()
    }
    
    //MARK: - Methods -
    func saveToken(accessToken: String) {
        keychainManager.save(accessToken, forKey: "authToken")
        keychainManager.delete(forKey: "googleEmail")
        isLoggedIn = true
    }
    
    func deleteToken() {
        keychainManager.delete(forKey: "authToken")
        keychainManager.delete(forKey: "googleEmail")
        keychainManager.delete(forKey: "googleName")
        isLoggedIn = false
    }
    
    func getToken() -> String? {
        return (keychainManager.get(forKey: "authToken")) ?? .empty
    }
    
    func hasValidSession() -> Bool {
        return getToken() != nil || getGoogleEmail() != nil
    }
    
    func getGoogleEmail() -> String? {
        keychainManager.get(forKey: "googleEmail")
    }
    
    func getUserName() -> String? {
        keychainManager.get(forKey: "googleName")
    }
    
    func saveGoogleUser(email: String, name: String) {
        keychainManager.save(email, forKey: "googleEmail")
        keychainManager.save(name, forKey: "googleName")
        keychainManager.delete(forKey: "authToken") // Por si acaso
        isLoggedIn = true
    }
}
