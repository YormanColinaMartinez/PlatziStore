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
    @Published var name: String = .empty
    @Published var email: String = .empty
    @Published var password: String = .empty
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var accessToken: String = .empty
    @Published var confirmPassword: String = .empty
    @Published var isSignUpMode: Bool = false
    
    var isFormValid: Bool {
        return email.contains("@") && !password.isEmpty
    }
    
    func login() async -> String? {
        isSignUpMode = false
        guard isFormValid else {
            self.errorMessage = Strings.ErrorMessage.enterValidData.description
            return nil
        }
        
        self.isLoading = true
        self.errorMessage = nil

        defer {
            self.isLoading = false
        }

        do {
            guard let token = try await AuthService().login(email: email, password: password) else {
                return nil
            }
            self.accessToken = token
            return token
        } catch let error as ServiceError {
            self.errorMessage = error.userFriendlyMessage
            return nil
        } catch {
            self.errorMessage = Strings.ErrorMessage.unknowError.description
            return nil
        }
    }
    
    func createUser() async throws -> String? {
        isSignUpMode = true
        guard isFormValid else {
            self.errorMessage = Strings.ErrorMessage.enterValidData.description
            return nil
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            guard let token = try await AuthService().register(name: name, email: email, password: password) else {
                return nil
            }
            accessToken = token
            return token
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func validateForm(isSignUpMode: Bool, confirmPassword: String) -> String? {
        if email.isEmpty || !email.contains("@") {
            return "Please enter a valid email address."
        }
        if password.isEmpty {
            return "Por favor, ingresa una contraseña válida."
        }
        if isSignUpMode && password != confirmPassword {
            return "Las contraseñas no coinciden."
        }
        return nil
    }
}
