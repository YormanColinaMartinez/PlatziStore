//
//  AuthService.swift
//  PlatziStore
//
//  Created by mac on 7/04/25.
//

import Foundation

final class AuthService: AuthServiceProtocol {
    
    // MARK: - Methods -
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
            endpoint: Endpoints.login.description,
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
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw error
        }
        
        do {
            return try JSONDecoder().decode(responseType, from: await getData(request: request))
        } catch let decodingError as Swift.DecodingError {
            throw ServiceError.decodingError(decodingError)
        }
    }
    
    func getData(request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            return data
        case 401:
            throw ServiceError.authenticationFailed
        case 400...499:
            throw ServiceError.clientError(statusCode: httpResponse.statusCode)
        case 500...599:
            throw ServiceError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw ServiceError.unexpectedStatusCode(statusCode: httpResponse.statusCode)
        }
    }
    
    func loginWithGoogle(email: String, name: String) async throws -> String? {
        let body = [
            "email": email,
            "name": name
        ]
        
        let authResponse = try await sendRequest(
            endpoint: "/auth/google",
            body: body,
            responseType: AuthResponse.self
        )
        return authResponse.access_token
    }

}
