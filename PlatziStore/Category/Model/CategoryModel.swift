//
//  CategoryModel.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import Foundation

struct CategoryModel: Decodable {
    let id: Int
    let name: String
    let image: String
    let creationAt: Date
    let updatedAt: Date
    
    enum CodingKeys: CodingKey {
        case id, name, image, creationAt, updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.image = try container.decode(String.self, forKey: .image)
        let creationAtString = try container.decode(String.self, forKey: .creationAt)
        let updatedAtString: String = try container.decode(String.self, forKey: .updatedAt)
        let dateFormatter = ISO8601DateFormatter()
        creationAt = dateFormatter.date(from: creationAtString) ?? Date()
        updatedAt = dateFormatter.date(from: updatedAtString) ?? Date()
    }
}
