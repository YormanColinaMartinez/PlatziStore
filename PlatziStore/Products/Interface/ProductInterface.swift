//
//  ProductServiceInterface.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import Foundation
import CoreData

protocol ProductServiceInterface: AnyObject {
    func fetchProducts(url: String) async throws -> [ProductModel]
    func saveProducts(_ products: [ProductModel], context: NSManagedObjectContext) async throws
}
