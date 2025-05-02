//
//  Strings.swift
//  PlatziStore
//
//  Created by mac on 7/04/25.
//

import Foundation

enum Strings {
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
        
        var description: String { rawValue }
    }
    
    enum Colors: String {
        case mainColorApp = "mainColorApp"
        case platziGreenColor = "platziGreenColor"
        
        var description: String { rawValue }
    }
    
    enum Icons: String {
        case platziLogo = "platzi-logo"
        case blackPlatziLogo = "black-paltzi-logo"
        
        var description: String { rawValue }
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
}
