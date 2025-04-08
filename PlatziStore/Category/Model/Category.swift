//
//  CategoryModel.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import Foundation
import CoreData

extension Category {
    static func from(response: CategoryResponse, context: NSManagedObjectContext) -> Category {
        let category = Category(context: context)
        category.id = response.id
        category.name = response.name
        category.image = response.image
        category.creationAt = ISO8601DateFormatter().date(from: response.creationAt) ?? Date()
        category.updatedAt = ISO8601DateFormatter().date(from: response.updatedAt) ?? Date()
        return category
    }
}

struct CategoryResponse: Decodable {
    let id: Int64
    let name: String
    let image: String
    let creationAt: String
    let updatedAt: String
}
