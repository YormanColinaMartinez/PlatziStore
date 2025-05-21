//
//  LoginViewModel.swift
//  PlatziStore
//
//  Created by mac on 7/04/25.
//

import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    
    //MARK: - Properties -
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
    let logger = LoginLogger()
    private let authService: AuthServiceProtocol
    
    //MARK: - Initializers -
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    //MARK: - Internal Methods -
    func login() async -> String? {
        isSignUpMode = false
        guard isFormValid else {
            self.errorMessage = ErrorMessage.enterValidData.description
            return nil
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        defer {
            self.isLoading = false
        }
        
        var success = false
        var tokenResult: String? = nil
        
        do {
            if let token = try await authService.login(email: email, password: password) {
                self.accessToken = token
                tokenResult = token
                success = true
            }
        } catch let error as ServiceError {
            self.errorMessage = error.userFriendlyMessage
        } catch {
            self.errorMessage = ErrorMessage.unknowError.description
        }
        
        await logger.logAttempt(email: email, success: success)
        
        return tokenResult
    }

    
    func createUser() async throws -> String? {
        isSignUpMode = true
        guard isFormValid else {
            self.errorMessage = ErrorMessage.enterValidData.description
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
            self.errorMessage = ErrorMessage.unknowError.description
            throw error
        }
    }
    
    func validateForm(isSignUpMode: Bool, confirmPassword: String) -> String? {
        if email.isEmpty || !email.contains("@") {
            return ErrorMessage.enterValidEmail.description
        }
        if password.isEmpty {
            return ErrorMessage.enterValidPassword.description
        }
        if isSignUpMode && password != confirmPassword {
            return ErrorMessage.passwordsDoNotMatch.description
        }
        return nil
    }
}
