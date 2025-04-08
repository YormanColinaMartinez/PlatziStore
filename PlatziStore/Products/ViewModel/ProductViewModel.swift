//
//  ProductViewModel.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import Foundation
import CoreData

class ProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var categories: [Category] = []

    let service: NetworkService
    private let context: NSManagedObjectContext

    init(service: NetworkService = ApiService(), context: NSManagedObjectContext) {
        self.service = service
        self.context = context
    }

    @MainActor
    func loadProducts() async {
        do {
            let products = try await service.fetchEntities(
                urlString: "https://api.escuelajs.co/api/v1/products",
                context: context,
                transform: Product.from
            )
            self.products = products
        } catch {
            print("Error al cargar productos:", error)
        }
    }

    @MainActor
    func loadCategories() async {
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
