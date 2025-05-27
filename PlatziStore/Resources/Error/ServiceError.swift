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
            return UserErrorMessage.invalidURL.message
        case .networkError(let error):
            let nsError = error as NSError
            if nsError.code == NSURLErrorNotConnectedToInternet {
                return UserErrorMessage.networkError(error).message
            } else {
                return UserErrorMessage.connectionError.message
            }
        case .noData:
            return UserErrorMessage.noData.message
        case .decodingError:
            return UserErrorMessage.decodingError.message
        case .invalidResponse:
            return UserErrorMessage.invalidResponse.message
        case .userNotFound:
            return UserErrorMessage.userNotFound.message
        case .authenticationFailed:
            return UserErrorMessage.authenticationFailed.message
        case .serverError(let statusCode):
            return UserErrorMessage.serverError(statusCode: statusCode).message
        case .timeout:
            return UserErrorMessage.timeout.message
        case .unknownError:
            return UserErrorMessage.unknownError.message
        case .unauthorized:
            return UserErrorMessage.unauthorized.message
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

enum CoreDataError: Error {
    case missingContext
}
