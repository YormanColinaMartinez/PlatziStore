//
//  CategoryInterface.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import Foundation

protocol CategoryInterface {
    func fetchData<T: Decodable>(url: String) async throws -> T
    func fetchCategories(url: String) async throws -> [CategoryModel]
    func fetchCategory(url: String) async throws -> CategoryModel
}
