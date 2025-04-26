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
            
            // Imagen seleccionada (preview)
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .clipShape(Circle())
            }

            Button("Select Profile Picture") {
                showImagePicker = true
            }
            
            if viewModel.isLoading {
                ProgressView("Actualizando...")
            } else {
                Button("Guardar cambios") {
                    Task {
                        await viewModel.updateProfile(name: newName, email: newEmail, image: selectedImage)
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
    }
}


