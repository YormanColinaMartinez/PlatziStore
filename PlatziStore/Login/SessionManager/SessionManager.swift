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
        guard !token.isEmpty else { return false }
        
        // Implementa la lógica para verificar si el token JWT está expirado
        // Esto requiere decodificar el JWT y verificar la fecha de expiración
        // Por ahora devolvemos true si existe un token
        
        return true
    }
}
