//
//  ProfileView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("mainColorApp", bundle: nil).ignoresSafeArea()

                if viewModel.isLoading {
                    ProgressView("Cargando perfil...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                } else if viewModel.isLoggingOut {
                    VStack {
                        ProgressView("Cerrando sesión...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                        Text("Por favor espera...")
                            .foregroundColor(.white)
                            .padding(.top, 8)
                    }
                } else {
                    VStack(spacing: 16) {
                        if let user = viewModel.user {
                            AsyncImage(url: URL(string: user.avatar)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            } placeholder: {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 120, height: 120)
                            }

                            Text(user.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            NavigationLink(destination: EditProfileView(viewModel: viewModel)) {
                                Text("Edit Profile")
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.teal)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                        }

                        VStack(spacing: 0) {
                            ProfileRow(title: "My Orders", systemImage: "calendar", destination: Text("My Orders View"))
                            ProfileRow(title: "Shipping Addresses", systemImage: "location.fill", destination: Text("Shipping Addresses View"))
                            ProfileRow(title: "Payment Methods", systemImage: "creditcard.fill", destination: Text("Payment Methods View"))
                            ProfileRow(title: "Settings", systemImage: "gearshape.fill", destination: Text("Settings View"))
                        }
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .padding()

                        Spacer()

                        Button(action: {
                            Task {
                                await viewModel.logOut()
                            }
                        }) {
                            if viewModel.isLoggingOut {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Log Out")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(height: 44)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        .disabled(viewModel.isLoggingOut)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.getUserInfo()
            }
        }
    }
}

struct ProfileRow<Destination: View>: View {
    let title: String
    let systemImage: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 16) {
                Image(systemName: systemImage)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
                Text(title)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 14)
            .padding(.horizontal)
        }
        .background(Color.clear)
    }
}

