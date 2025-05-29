//
//  ProductModel.swift
//  PlatziStore
//
//  Created by mac on 28/05/25.
//

import Foundation

struct ProductModel: Codable, Identifiable {
    let id: Int
    let title: String
    let slug: String
    let price: Int
    let description: String
    let category: CategoryModel
    let images: [String]
}

struct CategoryModel: Codable, Identifiable {
    let id: Int
    let name: String
    let slug: String
    let price: Int
    let image: String
}
