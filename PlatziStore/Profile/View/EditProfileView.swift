//
//  EditProfileView.swift
//  PlatziStore
//
//  Created by mac on 25/04/25.
//

import SwiftUI

struct EditProfileView: View {
    //MARK: - Properties -
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    @State private var newName: String
    @State private var newEmail: String
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var imageURL: String = .empty
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        _newName = State(initialValue: viewModel.user?.name ?? .empty)
        _newEmail = State(initialValue: viewModel.user?.email ?? .empty)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(EditProfile.editProfile.description)
                .font(.title)
                .fontWeight(.bold)
            
            TextField(Login.name.description, text: $newName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField(Login.email.description, text: $newEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
        
            Button(EditProfile.selectPicture.description) {
                showImagePicker = true
            }
            
            if viewModel.isLoading {
                ProgressView(EditProfile.updating.description)
            } else {
                Button(EditProfile.saveChanges.description) {
                    Task {
                        await viewModel.updateProfile(name: newName, email: newEmail, avatarUrl: imageURL)
                        dismiss()
                    }
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.teal)
                .cornerRadius(10)
            }
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .onChange(of: selectedImage) { newImage in
            if let image = newImage {
                if let imageURL = viewModel.saveImageToTemporaryDirectory(image: image) {
                }
            }
        }
    }
}
