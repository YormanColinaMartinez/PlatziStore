//
//  LoginView.swift
//  PlatziStore
//
//  Created by mac on 7/04/25.
//

import SwiftUI
import CoreData

struct LoginView: View {
    
    //MARK: - Properties -
    @StateObject var viewModel: LoginViewModel
    
    // MARK: - Body -
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    logoSection
                    formSection
                    LoginButtonSection(viewModel: viewModel)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    footerLogo
                }
                .padding(.top, 100)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Colors.mainColorApp.color)
                .onTapGesture {
                    UIApplication.shared.hideKeyboard()
                }
                .navigationDestination(isPresented: $viewModel.navigateToHome) {
                    TabBarView(sessionManager: viewModel.sessionManager)
                }
            }
            .scrollIndicators(.hidden)
            .background(Colors.mainColorApp.color)
        }
    }
    
    // MARK: - Subviews -
    private var logoSection: some View {
        HStack {
            Image(Icons.platziLogo.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.2)
            
            Text(Login.platziStore.description)
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
    
    private var footerLogo: some View {
        Image(Icons.blackPlatziLogo.description)
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .opacity(0.2)
            .background(.clear)
            .padding(.top, 50)
    }
}
