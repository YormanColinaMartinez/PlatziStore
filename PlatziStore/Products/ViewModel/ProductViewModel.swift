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
    
    //MARK: - Properties -
    @Published var products: [Product] = []
    @Published var categories: [Category] = []
    @Published var searchText: String = .empty
    @Published var selectedCategory: String?
    @Published var isSearching: Bool = false
    @Published var selectedProduct: Product?
    @Published var showDetail = false
    @Published var context: NSManagedObjectContext
    
    var cartManager: CartManager
    var filteredItems: [Product] {
        products.filter { product in
            let categoryName = product.categoryRelationship?.name ?? .empty
            let title = product.title ?? .empty
            let matchesCategory = selectedCategory == nil || categoryName == selectedCategory
            let matchesSearch = searchText.isEmpty || title.localizedCaseInsensitiveContains(searchText)
            return matchesCategory && matchesSearch
        }
    }
    private let service: NetworkService

    //MARK: - Initializers -
    init(cartManager: CartManager, context: NSManagedObjectContext, service: NetworkService = ApiService()) {
        self.service = service
        self.cartManager = cartManager
        self.context = context
    }

    //MARK: - Internal Methods -
    func loadProducts() async {
        do {
            let products = try await service.fetchEntities(
                urlString: "https://api.escuelajs.co/api/v1/products",
                context: context,
                transform: { response, context in
                    Product.from(response, context: context)
                }
            )
            self.products = products
        } catch {
            print("Error al cargar productos:", error.localizedDescription)
        }
    }
    
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
    

    func isValidURL(_ urlString: String?) -> Bool {
        guard let urlString = urlString,
              let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url),
              !urlString.contains("imgur.com/removed") else {
            return false
        }
        return true
    }
}
