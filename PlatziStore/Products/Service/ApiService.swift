//
//  ProductService.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import Foundation
import CoreData

class ApiService: NetworkService {
    
    //MARK: - Properties -
    private let session: URLSession
    
    //MARK: - Initializers -
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    //MARK: - Internal Methods -
    func fetchEntities<ResponseType: Decodable, EntityType>(
        urlString: String,
        context: NSManagedObjectContext,
        transform: @escaping (ResponseType, NSManagedObjectContext) -> EntityType
    ) async throws -> [EntityType] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await session.data(from: url)
        let decoder = JSONDecoder()
        let decoded = try decoder.decode([ResponseType].self, from: data)
        
        let entities = decoded.map { transform($0, context) }

        return entities
    }
}
