//
//  ProductImage.swift
//  PlatziStore
//
//  Created by mac on 23/05/25.
//

import Foundation
import CoreData

extension ProductImage {
    static func from(_ url: String, context: NSManagedObjectContext) -> ProductImage {
        let image = ProductImage(context: context)
        image.url = url
        return image
    }
}
