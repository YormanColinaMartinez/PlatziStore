//
//  ProductViewModel.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI
import CoreData

@MainActor
class ProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var categories: [Category] = []
    @Published var searchText: String = .empty
    @Published var selectedCategory: String?
    @Published var isSearching: Bool = false
    @Published var selectedProduct: Product?
    @Published var showDetail = false
    var cartManager: CartManager
    private let service: NetworkService

    init(cartManager: CartManager, service: NetworkService = ApiService()) {
        self.service = service
        self.cartManager = cartManager
    }

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
