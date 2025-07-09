//
//  LoginButtonSection.swift
//  PlatziStore
//
//  Created by mac on 23/05/25.
//

import SwiftUI

struct LoginButtonSection: View {
    //MARK: - Properties -
    @ObservedObject var viewModel: LoginViewModel
    
    // MARK: - Body -
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if viewModel.isSignUpMode {
                        viewModel.isSignUpMode = false
                    } else {
                        Task {
                            let errorMessage = viewModel.validateForm(isSignUpMode: viewModel.isSignUpMode, confirmPassword: viewModel.confirmPassword)
                            if let error = errorMessage {
                                viewModel.errorMessage = error
                                return
                            }
                            if await viewModel.login() != nil {
                                viewModel.navigateToHome = true
                                viewModel.isLoading = false
                            }
                        }
                    }
                    viewModel.errorMessage = nil
                }
            }) {
                Text(viewModel.isSignUpMode ? Login.backToLogin.description : Login.login.description).bold()
            }
            .frame(width: 150, height: 50)
            .foregroundColor(.white)
            .background(.blue)
            .cornerRadius(12)
            .transition(.opacity)
            
            
            Button(action: {
                withAnimation {
                    if viewModel.isSignUpMode {
                        Task {
                            let errorMessage = viewModel.validateForm(isSignUpMode: viewModel.isSignUpMode, confirmPassword: viewModel.confirmPassword)
                            if let error = errorMessage {
                                viewModel.errorMessage = error
                                return
                            }
                            
                            if ((try await viewModel.createUser()) != nil) {
                                viewModel.isLoading = false
                                viewModel.navigateToHome = true
                            }
                        }
                    } else {
                        viewModel.isSignUpMode = true
                    }
                    viewModel.errorMessage = nil
                }
            }) {
                Text(Login.signUp.description).bold()
            }
            .frame(width: 150, height: 50)
            .foregroundColor(.white)
            .background(Colors.platziGreenColor.color)
            .cornerRadius(12)
        }
        .padding(.top, 20)
    }
}
