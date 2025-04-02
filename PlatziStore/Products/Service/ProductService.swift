//
//  ProductService.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import Foundation
import CoreData

class ProductService: ProductServiceInterface {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchProducts(url: String) async throws -> [ProductModel] {
        guard let url: URL = URL(string: url) else {
            throw ServiceError.invalidURL
        }
        
        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ServiceError.invalidResponse
        }
        
        do  {
            let products = try JSONDecoder().decode([ProductModel].self, from: data)
            return products
        }  catch let decodingError as Swift.DecodingError {
            throw ServiceError.decodingError(decodingError)
        }
    }
    
    func saveProducts(_ products: [ProductModel], context: NSManagedObjectContext) async throws {
        try await context.perform {
            for product in products {
                let productEntity = Product(context: context)
                productEntity.id = Int64(product.id)
                productEntity.price = product.price
                productEntity.productDescription = product.description
                productEntity.images = product.images as NSArray
            }
            try context.save()
        }
    }
    
    func fetchAndSaveProducts(context: NSManagedObjectContext) async throws {
        do {
            let products = try await fetchProducts(url: "https://api.example.com/products")
            try await saveProducts(products, context: context)
        } catch {
            throw error
        }
    }
}
