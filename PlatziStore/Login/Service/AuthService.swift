//
//  AuthService.swift
//  PlatziStore
//
//  Created by mac on 7/04/25.
//

import Foundation

final class AuthService {
    static let shared = AuthService()
    private let baseULR: String = "https://api.escuelajs.co/api/v1"
    private var token: String? {
        get { UserDefaults.standard.string(forKey: "authToken") }
        set { UserDefaults.standard.set(newValue, forKey: "authToken") }
    }
    
    // MARK: - Registro
    func register(name: String, email: String, password: String) async throws -> String? {
        guard let url = URL(string: "\(baseULR)/users/") else {
            throw ServiceError.invalidURL
        }
        
        let body: [String: String] = [
            "name": name,
            "email": email,
            "password": password,
            "avatar": "https://i.imgur.com/LDOO4Qs.jpg"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ServiceError.invalidResponse
            }
            
            guard httpResponse.statusCode == 201 else {
                throw ServiceError.serverError(statusCode: httpResponse.statusCode)
            }
            
            let user = try JSONDecoder().decode(UserModel.self, from: data)
            return try await login(email: user.email, password: user.password)
        } catch let error as Swift.DecodingError {
            throw ServiceError.decodingError(error)
        } catch {
            throw ServiceError.networkError(error)
        }
    }
    
    // MARK: - Inicio de sesión
    func login(email: String, password: String) async throws -> String? {
        guard let url = URL(string: "\(baseULR)/auth/login") else {
            throw ServiceError.invalidURL
        }
        
        let body: [String: String] = [
            "email": email,
            "password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ServiceError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
                if httpResponse.statusCode == 401 {
                    throw ServiceError.authenticationFailed
                } else {
                    throw ServiceError.serverError(statusCode: httpResponse.statusCode)
                }
            }
            
            let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
            self.token = authResponse.access_token
            return token ?? ""
        } catch let error as Swift.DecodingError {
            throw ServiceError.decodingError(error)
        } catch {
            throw ServiceError.networkError(error)
        }
    }
    
    // MARK: - Estado de autenticación
    func isAuthenticated() -> Bool {
        return token != nil
    }
    
    func logout() {
        token = nil
    }
}
