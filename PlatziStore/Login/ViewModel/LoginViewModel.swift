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
    @ObservedObject var sessionManager: SessionManager
    @Published var navigateToHome = false
    @Published var name: String = .empty
    @Published var email: String = .empty
    @Published var password: String = .empty
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var confirmPassword: String = .empty
    @Published var isSignUpMode: Bool = false
    
    var isFormValid: Bool {
        return email.contains("@") && !password.isEmpty
    }
    private let authService: AuthServiceProtocol
    
    //MARK: - Initializers -
    init(sessionManager: SessionManager, authService: AuthServiceProtocol = AuthService()) {
        self.sessionManager = sessionManager
        self.authService = authService
    }
    
    //MARK: - Methods -
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
        
        do {
            if let token = try await authService.login(email: email, password: password) {
                sessionManager.saveToken(accessToken: token)
            }
        } catch let error as ServiceError {
            self.errorMessage = error.userFriendlyMessage
        } catch {
            self.errorMessage = ErrorMessage.unknowError.description
        }
        return nil
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
            sessionManager.saveToken(accessToken: token)
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
