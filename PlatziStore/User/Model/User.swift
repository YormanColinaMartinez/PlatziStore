//
//  User.swift
//  PlatziStore
//
//  Created by mac on 7/04/25.
//

import Foundation

struct User: Decodable {
    let id: Int
    let email: String
    let password: String
    let name: String
    let role: String
    let avatar: String
    let creationAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: CodingKey {
        case id, email, password, name, role, avatar, creationAt, updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.password = try container.decode(String.self, forKey: .password)
        self.name = try container.decode(String.self, forKey: .name)
        self.role = try container.decode(String.self, forKey: .role)
        self.avatar = try container.decode(String.self, forKey: .avatar)
        let creationAtString = try container.decode(String.self, forKey: .creationAt)
        let updatedAtString: String = try container.decode(String.self, forKey: .updatedAt)
        let dateFormatter = ISO8601DateFormatter()
        creationAt = dateFormatter.date(from: creationAtString) ?? Date()
        updatedAt = dateFormatter.date(from: updatedAtString) ?? Date()
    }
}
