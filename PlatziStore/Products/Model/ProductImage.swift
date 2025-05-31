//
//  ProductImage.swift
//  PlatziStore
//
//  Created by mac on 23/05/25.
//

import Foundation
import CoreData

extension ProductImage {
    static func from(_ url: String?, context: NSManagedObjectContext) -> ProductImage? {
        guard context.persistentStoreCoordinator != nil else {
            print("ERRRRRRRRROOORRRRRRRR")
            return nil
        }
        
        let image = ProductImage(context: context)
        image.url = url ?? .empty
        return image
    }
}
