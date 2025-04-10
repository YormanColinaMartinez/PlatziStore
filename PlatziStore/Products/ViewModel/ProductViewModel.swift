//
//  ProductViewModel.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI
import CoreData

class ProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var categories: [Category] = []
    private let service: NetworkService

    init(service: NetworkService = ApiService()) {
        self.service = service
    }

    @MainActor
    func loadProducts(context: NSManagedObjectContext) async {
        do {
            let products = try await service.fetchEntities(
                urlString: "https://api.escuelajs.co/api/v1/products",
                context: context,
                transform: { response, context in
                    Product.from(response: response, context: context)
                }
            )
            self.products = products
        } catch {
            print("Error al cargar productos:", error.localizedDescription)
        }
    }
    
    @MainActor
    func loadCategories(context: NSManagedObjectContext) async {
        do {
            let categories = try await service.fetchEntities(
                urlString: "https://api.escuelajs.co/api/v1/categories",
                context: context,
                transform: Category.from
            )
            self.categories = categories
        } catch {
            print("Error al cargar categorías:", error)
        }
    }
}
