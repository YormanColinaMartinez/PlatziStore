//
//  ProfileContentView.swift
//  PlatziStore
//
//  Created by mac on 27/05/25.
//

import SwiftUI

struct ProfileContentView: View {
    //MARK: - Properties -
    @ObservedObject var viewModel: ProfileViewModel
    
    //MARK: - Body -
    var body: some View {
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
                    Text(Profile.editProfile.description)
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
                ProfileRow(title: Profile.myOrders.description, systemImage: Icons.calendar.description, destination: OrdersView(context: viewModel.context))
                ProfileRow(title: Profile.addresses.description, systemImage: Icons.locationFill.description, destination: Text(ProfileViewDestinations.shippingView.description))
                ProfileRow(title: Profile.paymentMethods.description, systemImage: Icons.creditCard.description, destination: Text(ProfileViewDestinations.paymentView.description))
                ProfileRow(title: Profile.settings.description, systemImage: Icons.gearshapeFill.description, destination: Text(ProfileViewDestinations.settingsView.description))
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
                    Text(Profile.logOut.description)
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
