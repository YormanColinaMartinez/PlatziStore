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
        (imagesRelationship?.allObjects as? [ProductImage])?.compactMap { $0.url } ?? []
    }

    static func from(_ response: ProductResponse, context: NSManagedObjectContext) -> Product? {
        guard context.persistentStoreCoordinator != nil else {
            return nil
        }

        let product = Product(context: context)
        product.id = response.id
        product.title = response.title
        product.productDescription = response.productDescription
        product.price = response.price
        product.slug = response.slug
        
        for url in response.images where !url.isEmpty {
            if let image = ProductImage.from(url, context: context) {
                image.productRelationship = product
            }
        }
        product.categoryRelationship = Category.from(response.category, context: context)
        return product
    }
}

struct ProductResponse: Decodable {
    let id: Int64
    let title: String
    let price: Int64
    let productDescription: String
    let images: [String]
    let slug: String
    let category: CategoryResponse

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case productDescription = "description"
        case images
        case category
        case slug
    }
}
