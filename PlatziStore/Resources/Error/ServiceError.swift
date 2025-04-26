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
            return "Error interno de la aplicación. Por favor contacta al soporte."
        case .networkError(let error):
            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                return "No hay conexión a internet. Por favor verifica tu conexión."
            }
            return "Problema de conexión. Por favor intenta nuevamente."
        case .noData:
            return "El servidor no respondió con datos válidos."
        case .decodingError:
            return "Error procesando la respuesta del servidor."
        case .invalidResponse:
            return "Respuesta inválida del servidor."
        case .userNotFound:
            return "Usuario no encontrado. Verifica tu email."
        case .authenticationFailed:
            return "Email o contraseña incorrectos. Por favor verifica tus credenciales."
        case .serverError(let statusCode):
            return "Error del servidor (código \(statusCode)). Por favor intenta más tarde."
        case .timeout:
            return "El servidor está tardando demasiado en responder. Por favor intenta nuevamente."
        case .unknownError:
            return "Error desconocido. Por favor contacta al soporte."
        case . unauthorized:
            return "Ha fallado la autorización"
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
