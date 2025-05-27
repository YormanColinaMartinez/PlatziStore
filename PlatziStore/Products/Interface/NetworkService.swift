//
//  ProductServiceInterface.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import Foundation
import CoreData

protocol NetworkService {
    func fetchEntities<Response: Decodable, Entity>(
        urlString: String,
        context: NSManagedObjectContext,
        transform: @escaping (Response, NSManagedObjectContext) -> Entity
    ) async throws -> [Entity]
}
