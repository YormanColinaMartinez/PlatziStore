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
    
    func updateProfile(name: String, email: String, avatarUrl: String?) async {
        isLoading = true
        defer { isLoading = false }
        
        guard let userId = user?.id else {
            print("Error: No se encontró el ID del usuario")
            return
        }
        
        guard let url = URL(string: "https://api.escuelajs.co/api/v1/users/\(userId)") else {
            print("Error: No se pudo crear la URL")
            return
        }

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
        
        if let avatarUrl = avatarUrl {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"avatar\"\r\n\r\n")
            body.append("\(avatarUrl)\r\n")
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

    
    func uploadImageToImgBB(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        
        let base64String = imageData.base64EncodedString()
        let apiKey = "TU_API_KEY_DE_IMGBB"
        let url = URL(string: "https://api.imgbb.com/1/upload?key=\(apiKey)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body = "image=\(base64String)"
        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let dataDict = json["data"] as? [String: Any],
                  let imageURL = dataDict["url"] as? String else {
                completion(nil)
                return
            }
            completion(imageURL)
        }.resume()
    }
    
    func saveImageToTemporaryDirectory(image: UIImage) -> URL? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error: No se pudo convertir la imagen en datos.")
            return nil
        }
        
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = tempDirectory.appendingPathComponent(fileName)
    
        do {
            try imageData.write(to: fileURL)
            print("Imagen guardada en: \(fileURL)")
            return fileURL
        } catch {
            print("Error al guardar la imagen: \(error)")
            return nil
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
