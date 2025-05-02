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
    private let authService: AuthServiceProtocol
    
    var isFormValid: Bool {
        return email.contains("@") && !password.isEmpty
    }
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
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
            guard let token = try await authService.login(email: email, password: password) else {
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
            guard let token = try await authService.register(name: name, email: email, password: password) else {
                return nil
            }
            accessToken = token
            return token
        } catch {
            self.errorMessage = Strings.ErrorMessage.unknowError.description
            throw error
        }
    }
    
    func validateForm(isSignUpMode: Bool, confirmPassword: String) -> String? {
        if email.isEmpty || !email.contains("@") {
            return Strings.ErrorMessage.enterValidEmail.description
        }
        if password.isEmpty {
            return Strings.ErrorMessage.enterValidPassword.description
        }
        if isSignUpMode && password != confirmPassword {
            return Strings.ErrorMessage.passwordsDoNotMatch.description
        }
        return nil
    }
}
