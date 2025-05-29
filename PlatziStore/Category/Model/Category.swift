//
//  CategoryModel.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import Foundation
import CoreData

extension Category {
    static func from(_ response: CategoryResponse, context: NSManagedObjectContext) -> Category? {
        guard context.persistentStoreCoordinator != nil else {
            return nil
        }

        let category = Category(context: context)
        category.id = response.id
        category.name = response.name
        category.image = response.image

        return category
    }
}

struct CategoryResponse: Decodable {
    let id: Int64
    let name: String
    let image: String
    let slug: String
}
