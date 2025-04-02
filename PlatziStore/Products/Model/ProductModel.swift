//
//  ProductModel.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import Foundation

struct ProductModel: Identifiable, Decodable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let images: [String]
    let creationAt: Date
    let updatedAt: Date
    let category: CategoryModel
    
    enum CodingKeys: CodingKey {
        case id, title, price, description, images, creationAt, updatedAt, category
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        price = try container.decode(Double.self, forKey: .price)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        images = try container.decode([String].self, forKey: .images)
        category = try container.decode(CategoryModel.self, forKey: .category)
        let creationAtString = try container.decode(String.self, forKey: .creationAt)
        let updatedAtString: String = try container.decode(String.self, forKey: .updatedAt)
        let dateFormatter = ISO8601DateFormatter()
        creationAt = dateFormatter.date(from: creationAtString) ?? Date()
        updatedAt = dateFormatter.date(from: updatedAtString) ?? Date()
        
    }
}
