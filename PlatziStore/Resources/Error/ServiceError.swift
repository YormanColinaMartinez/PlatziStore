//
//  ServiceError.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import Foundation

enum ServiceError: Error, Equatable, LocalizedError {
    case invalidURL
    case networkError(Error)
    case noData
    case decodingError(Swift.DecodingError)
    case invalidResponse
    case userNotFound
    case authenticationFailed
    case serverError(statusCode: Int)
    case timeout
    case unknownError
    case unauthorized
    
    var userFriendlyMessage: String {
        switch self {
        case .invalidURL:
            return "Internal application error. Please contact support."
        case .networkError(let error):
            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                return "There's no internet connection. Please check your connection."
            }
            return "Connection problem. Please try again."
        case .noData:
            return "The server did not respond with valid data."
        case .decodingError:
            return "Error processing server response."
        case .invalidResponse:
            return "Invalid response from the server."
        case .userNotFound:
            return "User not found. Please check your email."
        case .authenticationFailed:
            return "Email or password incorrect. Please verify your credentials."
        case .serverError(let statusCode):
            return "Server Error (código \(statusCode)). Please try later."
        case .timeout:
            return "The server is taking too long to respond. Please try again."
        case .unknownError:
            return "Unknow error. Please contact support."
        case . unauthorized:
            return "The authorizarion has failed"
        }
    }

    static func == (lhs: ServiceError, rhs: ServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.noData, .noData),
             (.invalidResponse, .invalidResponse),
             (.userNotFound, .userNotFound),
             (.authenticationFailed, .authenticationFailed),
             (.timeout, .timeout),
             (.unknownError, .unknownError):
            return true
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)
        case (.decodingError(let lhsError), .decodingError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.serverError(let lhsStatus), .serverError(let rhsStatus)):
            return lhsStatus == rhsStatus
        default:
            return false
        }
    }
}
