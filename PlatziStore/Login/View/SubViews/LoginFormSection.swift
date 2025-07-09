//
//  LoginFormSection.swift
//  PlatziStore
//
//  Created by mac on 4/06/25.
//

import SwiftUI

struct LoginFormSection: View {
    //MARK: - Properties -
    @ObservedObject var viewModel: LoginViewModel
    
    // MARK: - Body -
    var body: some View {
        VStack(spacing: 20) {
            if viewModel.isSignUpMode {
                CustomTextField(text: $viewModel.name, placeholder: Login.name.description)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .onChange(of: viewModel.name) {
                        viewModel.name = viewModel.name
                        viewModel.errorMessage = nil
                    }
            }
            
            CustomTextField(text: $viewModel.email, placeholder: Login.email.description)
                .keyboardType(.emailAddress)
                .onChange(of: viewModel.email) {
                    viewModel.email = viewModel.email.lowercased()
                    viewModel.errorMessage = nil
                }
            
            CustomTextField(text: $viewModel.password, placeholder: Login.password.description, isSecure: true)
                .onChange(of: viewModel.password) {
                    viewModel.password = viewModel.password
                    viewModel.errorMessage = nil
                }
            
            if viewModel.isSignUpMode {
                CustomTextField(text: $viewModel.confirmPassword, placeholder: Login.confirmPassword.description, isSecure: true)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
    }
}
