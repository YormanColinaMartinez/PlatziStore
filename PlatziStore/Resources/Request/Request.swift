//
//  Request.swift
//  PlatziStore
//
//  Created by mac on 27/05/25.
//

import Foundation

enum RequestLocalizations: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case bearer = "Bearer"
    case authorization = "Authorization"
    case patch = "PATCH"
    
    var description: String { return rawValue }
}
