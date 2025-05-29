//
//  AuthService.swift
//  PlatziStore
//
//  Created by mac on 7/04/25.
//

import Foundation

final class AuthService: AuthServiceProtocol {
    
    // MARK: - Internal Methods -
    func register(name: String, email: String, password: String) async throws -> String? {
        let body = [
            Request.name.description: name,
            Request.email.description: email,
            Request.password.description: password,
            Request.avatar.description: "https://i.imgur.com/LDOO4Qs.jpg"
        ]
        
        let user = try await sendRequest(
            endpoint: "/users/",
            body: body,
            responseType: User.self
        )
        return try await login(email: user.email, password: user.password)
    }
    
    func login(email: String, password: String) async throws -> String? {
        let body = [
            Request.email.description: email,
            Request.password.description: password
        ]
        
        let authResponse = try await sendRequest(
            endpoint: "/auth/login",
            body: body,
            responseType: AuthResponse.self
        )
        
        return authResponse.access_token
    }

    func sendRequest<T: Decodable>(
        endpoint: String,
        method: String = RequestLocalizations.post.description,
        body: [String: String],
        responseType: T.Type
    ) async throws -> T {
        guard let url = URL(string: Endpoints.baseUrl.rawValue) else {
            throw ServiceError.invalidURL
        }
        
        let fullURL = url.appendingPathComponent(endpoint)
        
        var request = URLRequest(url: fullURL)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print(error.localizedDescription)
            throw error
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ServiceError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if httpResponse.statusCode == 401 {
                    throw ServiceError.authenticationFailed
                } else {
                    throw ServiceError.serverError(statusCode: httpResponse.statusCode)
                }
            }
            
            let decodedResponse = try JSONDecoder().decode(responseType, from: data)
            return decodedResponse
        } catch let error as Swift.DecodingError {
            throw ServiceError.decodingError(error)
        } catch {
            throw ServiceError.networkError(error)
        }
    }
}
