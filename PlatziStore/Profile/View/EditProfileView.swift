//
//  EditProfileView.swift
//  PlatziStore
//
//  Created by mac on 25/04/25.
//

import SwiftUI

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    @State private var newName: String
    @State private var newEmail: String
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var imageURL: String = ""
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        _newName = State(initialValue: viewModel.user?.name ?? "")
        _newEmail = State(initialValue: viewModel.user?.email ?? "")
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Profile")
                .font(.title)
                .fontWeight(.bold)
            
            TextField("Name", text: $newName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField("Email", text: $newEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
        
            Button("Select Profile Picture") {
                showImagePicker = true
            }
            
            if viewModel.isLoading {
                ProgressView("Actualizando...")
            } else {
                Button("Guardar cambios") {
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
