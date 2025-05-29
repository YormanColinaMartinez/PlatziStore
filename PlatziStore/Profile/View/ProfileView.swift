//
//  ProfileView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI

struct ProfileView: View {
    //MARK: - Properties -
    @ObservedObject var viewModel: ProfileViewModel
    
    //MARK: - Body -
    var body: some View {
        NavigationView {
            ZStack {
                Color(Colors.mainColorApp.rawValue, bundle: nil).ignoresSafeArea()

                if viewModel.isLoading {
                    ProgressView(Profile.chargingProfile.description)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                } else if viewModel.isLoggingOut {
                    VStack {
                        ProgressView(Profile.loggingOut.description)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                        Text(Profile.pleaseWait.description)
                            .foregroundColor(.white)
                            .padding(.top, 8)
                    }
                } else {
                    ProfileContentView(viewModel: viewModel)
                }
            }
            .navigationTitle(Profile.profile.description)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.getUserInfo()
            }
        }
    }
}
