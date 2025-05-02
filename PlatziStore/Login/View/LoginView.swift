//
//  LoginView.swift
//  PlatziStore
//
//  Created by mac on 7/04/25.
//

import SwiftUI
import CoreData

struct LoginView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    logoSection
                    formSection
                    buttonSection
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    footerLogo
                }
                .padding(.top, 100)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor(named: Strings.Colors.mainColorApp.description) ?? .white))
                .onTapGesture {
                    UIApplication.shared.hideKeyboard()
                }
                .navigationDestination(isPresented: $viewModel.navigateToHome) {
                    HomeView(accessToken: viewModel.accessToken)
                }
            }
            .scrollIndicators(.hidden)
            .background(Color(UIColor(named: Strings.Colors.mainColorApp.description) ?? .white))
        }
    }
    
    // MARK: - Subviews
    private var logoSection: some View {
        HStack {
            Image(Strings.Icons.platziLogo.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text(Strings.Login.platziStore.description)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 10, x: -10, y: 10)
        }
        .padding(.vertical, 20)
    }
    
    private var formSection: some View {
        VStack(spacing: 20) {
            if viewModel.isSignUpMode {
                CustomTextField(text: $viewModel.name, placeholder: Strings.Login.name.description)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .onChange(of: viewModel.name) {
                        viewModel.name = viewModel.name.lowercased()
                        viewModel.errorMessage = nil
                    }
            }
            
            CustomTextField(text: $viewModel.email, placeholder: Strings.Login.email.description)
                .keyboardType(.emailAddress)
                .onChange(of: viewModel.email) {
                    viewModel.email = viewModel.email.lowercased()
                    viewModel.errorMessage = nil
                }
            
            CustomTextField(text: $viewModel.password, placeholder: Strings.Login.password.description, isSecure: true)
                .onChange(of: viewModel.password) {
                    viewModel.password = viewModel.password
                    viewModel.errorMessage = nil
                }
            
            if viewModel.isSignUpMode {
                CustomTextField(text: $viewModel.confirmPassword, placeholder: Strings.Login.confirmPassword.description, isSecure: true)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
    }
    
    private var buttonSection: some View {
        VStack(spacing: 20) {
            if viewModel.isLoading {
                ProgressView()
            }
            
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
                            await viewModel.navigateToHome = (viewModel.login() != nil)
                            viewModel.isLoading = false
                        }
                    }
                    viewModel.errorMessage = nil
                }
            }) {
                Text(viewModel.isSignUpMode ? Strings.Login.backToLogin.description : Strings.Login.login.description).bold()
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
                Text(Strings.Login.signUp.description).bold()
            }
            .frame(width: 150, height: 50)
            .foregroundColor(.white)
            .background(Color(UIColor(named: Strings.Colors.platziGreenColor.description) ?? UIColor.green.withAlphaComponent(0.5)))
            .cornerRadius(12)
        }
        .padding(.top, 20)
    }
    
    private var footerLogo: some View {
        Image(Strings.Icons.blackPlatziLogo.description)
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .opacity(0.2)
            .background(.clear)
            .padding(.top, 50)
    }
}
