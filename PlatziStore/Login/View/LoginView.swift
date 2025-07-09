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
                    LoginFormSection(viewModel: viewModel)
                    LoginButtonSection(viewModel: viewModel)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
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
}
