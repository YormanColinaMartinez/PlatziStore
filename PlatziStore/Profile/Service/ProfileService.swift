//
//  ProfileService.swift
//  PlatziStore
//
//  Created by mac on 25/04/25.
//

import Foundation

class ProfileService {
    
    //MARK: - Methods -
    func fetchUserProfile(accessToken: String) async throws -> UserProfile {
        guard let url = URL(string: Endpoints.fetchUserProfile.rawValue) else {
            throw ServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = RequestLocalizations.get.description
        request.setValue("\(RequestLocalizations.bearer.description) \(accessToken)", forHTTPHeaderField: RequestLocalizations.authorization.description)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ServiceError.serverError(statusCode: -1)
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 401:
                throw ServiceError.unauthorized
            default:
                throw ServiceError.serverError(statusCode: httpResponse.statusCode)
            }
            
            do {
                let userProfile = try JSONDecoder().decode(UserProfile.self, from: data)
                return userProfile
            } catch let decodingError as Swift.DecodingError {
                throw ServiceError.decodingError(decodingError)
            }
            
        } catch {
            throw ServiceError.unknownError
        }
    }
}
