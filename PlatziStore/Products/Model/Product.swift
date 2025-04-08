//
//  ProductModel.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import Foundation
import CoreData

extension Product {
    var imagesArray: [String] {
        return images as? [String] ?? []
    }
    
    static func from(response: ProductResponse, context: NSManagedObjectContext) -> Product {
        let product = Product(context: context)
        product.id = response.id
        product.title = response.title
        product.price = response.price
        product.productDescription = response.productDescription
        product.images = response.images as NSObject
        product.creationAt = ISO8601DateFormatter().date(from: response.creationAt) ?? Date()
        product.updatedAt = ISO8601DateFormatter().date(from: response.updatedAt) ?? Date()
        
        let category = Category(context: context)
        category.id = response.category.id
        category.name = response.category.name
        product.category = category
        return product
    }
}

struct ProductResponse: Decodable {
    let id: Int64
    let title: String
    let price: Double
    let productDescription: String
    let images: [String]
    let creationAt: String
    let updatedAt: String
    let category: CategoryResponse
}
