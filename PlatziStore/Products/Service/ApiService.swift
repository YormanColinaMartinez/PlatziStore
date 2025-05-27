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

        do {
            let (data, _) = try await session.data(from: url)
            let decoder = JSONDecoder()
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON recibido:", jsonString)
            }
            
            let decoded: [ResponseType]
            do {
                decoded = try decoder.decode([ResponseType].self, from: data)
            } catch let decodingError {
                print("Error detallado de decodificación:")
                print(decodingError)
                throw decodingError
            }

            let entities = decoded.map { transform($0, context) }

            do {
                try context.save()
                return entities
            } catch let coreDataError {
                print("Error al guardar en Core Data:", coreDataError)
                throw coreDataError
            }
        } catch {
            print("Error en la solicitud:", error)
            throw error
        }
    }
}
