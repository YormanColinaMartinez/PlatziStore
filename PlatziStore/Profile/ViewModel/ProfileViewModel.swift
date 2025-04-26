//
//  ProfileViewModel.swift
//  PlatziStore
//
//  Created by mac on 25/04/25.
//

import UIKit

class ProfileViewModel: ObservableObject {
    @Published var user: UserProfile?
    @Published var isLoading = true
    
    let service: ProfileService = ProfileService()
    let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func getUserInfo() async {
        do {
            let profile = try await service.fetchUserProfile(accessToken: accessToken)
            
            await MainActor.run {
                self.user = profile
                self.isLoading = false
            }
        } catch {
            print("Error al obtener perfil:", error)
            await MainActor.run {
                self.user = nil
                self.isLoading = false
            }
        }
    }
    
    func updateProfile(name: String, email: String, image: UIImage?) async {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: "https://api.escuelajs.co/api/v1/users/\(String(describing: user?.id))!") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n")
        body.append("\(name)\r\n")
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"email\"\r\n\r\n")
        body.append("\(email)\r\n")
        
        if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"avatar\"; filename=\"avatar.jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        }

        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de respuesta:", httpResponse.statusCode)
            }
            
            if let errorMessage = String(data: data, encoding: .utf8) {
                print("Mensaje del servidor:", errorMessage)
            }

            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: Respuesta inválida")
                return
            }
            
            let updatedUser = try JSONDecoder().decode(UserProfile.self, from: data)
            await MainActor.run {
                self.user = updatedUser
            }
        } catch {
            print("Error actualizando perfil:", error)
        }
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
