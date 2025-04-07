//
//  LoginService.swift
//  PlatziStore
//
//  Created by mac on 7/04/25.
//

import Foundation

class LoginService: LoginServiceInterface {
    
    //MARK: - Internal Properties -
    private let session: URLSession
    
    //MARK: - Initializers -
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    //MARK: - Internal Methods -
    func fetchUsersAsync(url: String) async throws -> [UserModel] {
        guard let url = URL(string: url) else {
            throw ServiceError.invalidURL
        }

        let request = URLRequest(url: url)

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw ServiceError.invalidResponse
            }
            
            do {
                let users = try JSONDecoder().decode([UserModel].self, from: data)
                return users
            } catch let decodingError as Swift.DecodingError {
                throw ServiceError.decodingError(decodingError)
            }
        } catch {
            throw ServiceError.networkError(error)
        }
    }
    
    func searchUser(email: String) async throws -> UserModel {
        let url = "https://api.escuelajs.co/api/v1/users/"

        do {
            let users: [UserModel] = try await fetchUsersAsync(url: url)
            
            if let user = users.first(where: { $0.email == email }) {
                return user
            } else {
                throw ServiceError.userNotFound
            }
        } catch {
            throw error
        }
    }
}
