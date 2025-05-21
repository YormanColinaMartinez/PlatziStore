//
//  LoginInterface.swift
//  PlatziStore
//
//  Created by mac on 2/05/25.
//

import Foundation

protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> String?
    func register(name: String, email: String, password: String) async throws -> String?
}

actor LoginLogger {
    private var attempts: [String] = []

    func logAttempt(email: String, success: Bool) {
        let status = success ? "✅ Éxito" : "❌ Fallo"
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
        let entry = "[\(timestamp)] Login de \(email): \(status)"
        attempts.append(entry)
        print(entry)
    }

    func getAttempts() -> [String] {
        return attempts
    }
}
