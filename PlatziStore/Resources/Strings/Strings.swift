//
//  Strings.swift
//  PlatziStore
//
//  Created by mac on 7/04/25.
//

import Foundation

enum Strings: String {
    case platziStore = "Platzi Store"
    case email = "Email"
    case password = "Password"
    case login = "Login"
    case signUp = "Sign Up"
    case empty = ""
}

enum Icons: String {
    case platziLogo = "platzi-logo"
    case blackPlatziLogo = "black-paltzi-logo"
}

enum ErrorMessage: String {
    case emailEmpty = "El email no puede estar vacío"
    case passwordEmpty = "La contraseña no puede estar vacía"
    case wrongPassword = "Contraseña incorrecta"
    case searchUser = "Error al buscar usuario:"
    case fetchingUsers = "Error fetching users:"
}

enum Colors: String {
    case mainColorApp = "mainColorApp"
    case platziGreenColor = "platziGreenColor"
}
