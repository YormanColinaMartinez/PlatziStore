//
//  Strings.swift
//  PlatziStore
//
//  Created by mac on 7/04/25.
//

import Foundation

enum Detail: String {
    case add = "Add"
    case addToCart = "Add to cart"
    case toCart = "toCart"
    
    var description: String { rawValue }
}

enum ErrorMessage: String {
    case emailEmpty = "The email cannot be empty"
    case passwordEmpty = "The password cannot be empty"
    case wrongPassword = "Incorrect password"
    case searchUser = "Error searching for user:"
    case fetchingUsers = "Error fetching users:"
    case enterValidData = "Please enter a valid email and password."
    case unknowError = "An unexpected error occurred. Please try again."
    case enterValidEmail = "Please enter a valid email address."
    case enterValidPassword = "Please enter a valid password."
    case passwordsDoNotMatch =  "The passwords do not match."
    
    var description: String { rawValue }
}

enum Products: String {
    case products = "Products"
    
    var description: String { return rawValue}
}

enum Login: String {
    case platziStore = "Platzi Store"
    case email = "Email"
    case password = "Password"
    case login = "Login"
    case signUp = "Sign Up"
    case backToLogin =  "Back to Login"
    case confirmPassword = "Confirm Password"
    case name = "Name"
    
    var description: String { rawValue }
}

enum EditProfile: String {
    case selectPicture = "Select Profile Picture"
    case updating = "Updating..."
    case saveChanges = "Guardar cambios"
    case editProfile = "Edit Profile"
    
    var description: String { rawValue }
}

enum Request: String {
    case name = "name"
    case email = "email"
    case password = "password"
    case avatar = "avatar"
    
    var description: String { rawValue }
}

enum UserErrorMessage: Error {
    case invalidURL
    case networkError(Error)
    case noData
    case decodingError
    case invalidResponse
    case userNotFound
    case authenticationFailed
    case serverError(statusCode: Int)
    case timeout
    case unknownError
    case unauthorized
    case connectionError

    var message: String {
        switch self {
        case .invalidURL:
            return "Internal application error. Please contact support."
        case .networkError:
            return "There's no internet connection. Please check your connection."
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
        case .serverError(let code):
            return "Server Error (código \(code)). Please try later."
        case .timeout:
            return "The server is taking too long to respond. Please try again."
        case .unknownError:
            return "Unknown error. Please contact support."
        case .unauthorized:
            return "The authorization has failed."
        case .connectionError:
            return "Connection problem. Please try again."
        }
    }
}
