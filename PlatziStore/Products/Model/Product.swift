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
    
    static func from(response: ProductResponse, context: NSManagedObjectContext) -> Product {
        let product = Product(context: context)
        product.id = response.id
        product.title = response.title
        product.price = response.price
        product.productDescription = response.productDescription
        product.slug = response.slug

        for url in response.images {
            let productImage = ProductImage(context: context)
            if !url.isEmpty {
                productImage.url = url
            } else {
                print("Imagen con URL vacía encontrada")
            }
            productImage.productRelationship = product
        }
        product.categoryRelationship = Category.from(response: response.category, context: context)

        
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
