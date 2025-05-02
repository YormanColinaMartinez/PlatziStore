//
//  EditProfileView.swift
//  PlatziStore
//
//  Created by mac on 25/04/25.
//

import SwiftUI

struct EditProfileView: View {
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
            Text(Strings.EditProfile.editProfile.description)
                .font(.title)
                .fontWeight(.bold)
            
            TextField(Strings.Login.name.description, text: $newName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField(Strings.Login.email.description, text: $newEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
        
            Button(Strings.EditProfile.selectPicture.description) {
                showImagePicker = true
            }
            
            if viewModel.isLoading {
                ProgressView(Strings.EditProfile.updating.description)
            } else {
                Button(Strings.EditProfile.saveChanges.description) {
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
//                    self.imageURL = image
                }
            }
        }
    }
}
