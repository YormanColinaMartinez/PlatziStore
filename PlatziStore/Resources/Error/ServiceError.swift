//
//  ServiceError.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import Foundation

enum ServiceError: Error, Equatable {
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
