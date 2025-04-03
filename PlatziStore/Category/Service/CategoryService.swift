//
//  CategoryService.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import Foundation

class CategoryService: CategoryInterface {
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func fetchData<T: Decodable>(url: String) async throws -> T {
        guard let url = URL(string: url) else {
            throw ServiceError.invalidURL
        }

        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ServiceError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let decodingError as Swift.DecodingError {
            throw ServiceError.decodingError(decodingError)
        }
    }

    func fetchCategories(url: String) async throws -> [CategoryModel] {
        return try await fetchData(url: url)
    }

    func fetchCategory(url: String) async throws -> CategoryModel {
        return try await fetchData(url: url)
    }
}
