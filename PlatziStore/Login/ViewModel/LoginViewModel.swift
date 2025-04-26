//
//  LoginViewModel.swift
//  PlatziStore
//
//  Created by mac on 7/04/25.
//

import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    @Published var navigateToHome = false
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var accessToken: String = ""
    
    var isFormValid: Bool {
        return email.contains("@") && !password.isEmpty
    }
    
    func login() async -> String? {
        guard isFormValid else {
            self.errorMessage = "Por favor, ingresa un email y contraseña válidos."
            return nil
        }
        
        self.isLoading = true
        self.errorMessage = nil

        defer {
            self.isLoading = false
        }

        do {
            guard let token = try await AuthService.shared.login(email: email, password: password) else {
                return nil
            }
            self.accessToken = token
            return token
        } catch let error as ServiceError {
            self.errorMessage = error.userFriendlyMessage
            return nil
        } catch {
            self.errorMessage = "Ocurrió un error inesperado. Por favor intenta nuevamente."
            return nil
        }
    }
    
    func createUser() async throws -> String? {
        guard isFormValid else {
            self.errorMessage = "Por favor, ingresa un email y contraseña válidos."
            return nil
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            guard let token = try await AuthService.shared.register(name: name, email: email, password: password) else {
                return nil
            }
            accessToken = token
            return token
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
