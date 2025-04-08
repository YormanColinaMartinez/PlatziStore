//
//  ProductServiceInterface.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import Foundation
import CoreData

protocol NetworkService {
    func fetchEntities<ResponseType: Decodable, EntityType>(
        urlString: String,
        context: NSManagedObjectContext,
        transform: @escaping (ResponseType, NSManagedObjectContext) -> EntityType
    ) async throws -> [EntityType]
}
