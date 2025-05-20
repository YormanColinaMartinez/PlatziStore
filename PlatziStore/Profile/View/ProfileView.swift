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
            if viewModel.isLoading {
                ProgressView("Cargando perfil...")
            } else {
                VStack(spacing: 20) {
                    HStack(alignment: .center) {
                        Text("Profile")
                            .frame(width: .infinity)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    
                    if let user = viewModel.user {
                        AsyncImage(url: URL(string: user.avatar)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                        } placeholder: {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 90, height: 90)
                        }
                        
                        Text(user.name)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        NavigationLink(destination: EditProfileView(viewModel: viewModel)) {
                            Text("Edit Profile")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.teal)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }

                    List {
                        NavigationLink(destination: Text("My Orders View")) {
                            Label("My Orders", systemImage: "calendar")
                        }
                        NavigationLink(destination: Text("Shipping Addresses View")) {
                            Label("Shipping Addresses", systemImage: "location.fill")
                        }
                        NavigationLink(destination: Text("Payment Methods View")) {
                            Label("Payment Methods", systemImage: "creditcard.fill")
                        }
                        NavigationLink(destination: Text("Settings View")) {
                            Label("Settings", systemImage: "gearshape.fill")
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
                .background(Color("mainColorApp", bundle: nil))
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .task {
            await viewModel.getUserInfo()
        }
    }
}
