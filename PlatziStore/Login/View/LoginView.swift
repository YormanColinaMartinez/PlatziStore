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
    @State private var isSignUpMode: Bool = false
    @State private var confirmPassword: String = ""
    
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
                .background(Color(UIColor(named: Colors.mainColorApp.rawValue) ?? .white))
                .onTapGesture {
                    UIApplication.shared.hideKeyboard()
                }
                .navigationDestination(isPresented: $viewModel.navigateToHome) {
                    HomeView(accessToken: viewModel.accessToken)
                    
                }
            }
            .scrollIndicators(.hidden)
            .background(Color(UIColor(named: Colors.mainColorApp.rawValue) ?? .white))
        }
    }
    
    // MARK: - Subviews
    private var logoSection: some View {
        HStack {
            Image(Icons.platziLogo.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text(Strings.platziStore.rawValue)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 10, x: -10, y: 10)
        }
        .padding(.vertical, 20)
    }
    
    private var formSection: some View {
        VStack(spacing: 20) {
            if isSignUpMode {
                CustomTextField(placeholder: "Name", text: $viewModel.name)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .onChange(of: viewModel.name) {
                        viewModel.name = viewModel.name.lowercased()
                        viewModel.errorMessage = nil
                    }
            }
            
            CustomTextField(placeholder: Strings.email.rawValue, text: $viewModel.email)
                .keyboardType(.emailAddress)
                .onChange(of: viewModel.email) {
                    viewModel.email = viewModel.email.lowercased()
                    viewModel.errorMessage = nil
                }
            
            CustomTextField(placeholder: Strings.password.rawValue, text: $viewModel.password, isSecure: true)
                .onChange(of: viewModel.password) {
                    viewModel.password = viewModel.password
                    viewModel.errorMessage = nil
                }
            
            if isSignUpMode {
                CustomTextField(placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
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
                    if isSignUpMode {
                        isSignUpMode = false
                    } else {
                        Task {
                            let errorMessage = viewModel.validateForm(isSignUpMode: isSignUpMode, confirmPassword: confirmPassword)
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
                Text(isSignUpMode ? "Back to Login" : Strings.login.rawValue).bold()
            }
            .frame(width: 150, height: 50)
            .foregroundColor(.white)
            .background(.blue)
            .cornerRadius(12)
            .transition(.opacity)
            
            Button(action: {
                withAnimation {
                    if isSignUpMode {
                        Task {
                            let errorMessage = viewModel.validateForm(isSignUpMode: isSignUpMode, confirmPassword: confirmPassword)
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
                        isSignUpMode = true
                    }
                    viewModel.errorMessage = nil
                }
            }) {
                Text(Strings.signUp.rawValue).bold()
            }
            .frame(width: 150, height: 50)
            .foregroundColor(.white)
            .background(Color(UIColor(named: Colors.platziGreenColor.rawValue) ?? UIColor.green.withAlphaComponent(0.5)))
            .cornerRadius(12)
        }
        .padding(.top, 20)
    }
    
    private var footerLogo: some View {
        Image(Icons.blackPlatziLogo.rawValue)
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .opacity(0.2)
            .background(.clear)
            .padding(.top, 50)
    }
}
