//
//  LoginViewModel.swift
//  PlatziStore
//
//  Created by mac on 7/04/25.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var navigateToHome = false
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var isFormValid: Bool {
        return email.contains("@") && !password.isEmpty
    }
    
    func login() async throws -> Bool {
        guard isFormValid else {
            errorMessage = "Por favor, ingresa un email y contraseña válidos."
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let success = try await AuthService.shared.login(email: email, password: password)
            if success {
                
            } else {
                errorMessage = "Credenciales inválidas"
            }
        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
        }
        
        isLoading = false
        return true
    }
    
    func createUser() async throws -> Bool {
        guard isFormValid else {
            errorMessage = "Por favor, ingresa un email y contraseña válidos."
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let success = try await AuthService.shared.register(name: name, email: email, password: password)
            return success
        } catch {
            return false
        }
    }
}
