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
        guard let url: URL = URL(string: url) else { return []}
        
        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return []
        }
        
        do  {
            let products = try JSONDecoder().decode([ProductModel].self, from: data)
            return products
        } catch _ as Swift.DecodingError {
            return []
        }
    }
    
    func saveProducts(_ products: [ProductModel], context: NSManagedObjectContext) async throws {
        
    }
}
