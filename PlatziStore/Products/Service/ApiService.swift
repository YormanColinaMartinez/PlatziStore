//
//  ProductService.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import Foundation
import CoreData

class ApiService: NetworkService {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchEntities<ResponseType: Decodable, EntityType>(
        urlString: String,
        context: NSManagedObjectContext,
        transform: @escaping (ResponseType, NSManagedObjectContext) -> EntityType
    ) async throws -> [EntityType] {
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode([ResponseType].self, from: data)
        
        let entities = decoded.map { transform($0, context) }
        
        try context.save()
        
        return entities
    }
    
    
    
    
    
//    func fetchProducts(url: String) async throws -> [Product] {
//        guard let url: URL = URL(string: url) else {
//            throw ServiceError.invalidURL
//        }
//        
//        let request = URLRequest(url: url)
//        let (data, response) = try await session.data(for: request)
//        
//        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            throw ServiceError.invalidResponse
//        }
//        
//        do  {
//            let products = try JSONDecoder().decode([Product].self, from: data)
//            return products
//        }  catch let decodingError as Swift.DecodingError {
//            throw ServiceError.decodingError(decodingError)
//        }
//    }
//    
//    func saveProducts(_ products: [Product], context: NSManagedObjectContext) async throws {
//        try await context.perform {
//            for product in products {
//                let productEntity = Product(context: context)
//                productEntity.id = Int64(product.id)
//                productEntity.price = product.price
//                productEntity.productDescription = product.description
//                productEntity.images = product.images as NSArray
//            }
//            try context.save()
//        }
//    }
//    
//    func fetchAndSaveProducts(context: NSManagedObjectContext) async throws {
//        do {
//            let products = try await fetchProducts(url: "https://api.example.com/products")
//            try await saveProducts(products, context: context)
//        } catch {
//            throw error
//        }
//    }
}
