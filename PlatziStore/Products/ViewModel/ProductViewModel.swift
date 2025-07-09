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
    @Published var errorMessage: String?
    @Published var showErrorAlert = false
    private var context: NSManagedObjectContext
    
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
        Task {
            await loadView()
        }
    }

    //MARK: - Internal Methods -
    func loadView() async {
        await loadCategories()
        await loadProducts()
    }
    
    func loadProducts() async {
        do {
            let products = try await service.fetchEntities(
                urlString: Endpoints.products.description,
                context: context,
                transform: { response, context in
                    Product.from(response, context: context)
                })
            self.products = products.compactMap { $0 }
        } catch {
                errorMessage = errorMessage(for: error)
                showErrorAlert = true
            print("Error al cargar productos:", error.localizedDescription)
        }
    }
    
    func loadCategories() async {
        do {
            let categories = try await service.fetchEntities(
                urlString: Endpoints.categories.description,
                context: context,
                transform: { response, context in
                    Category.from(response, context: context)
                })
            self.categories = categories.compactMap { $0 }
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
    
    private func errorMessage(for error: Error) -> String {
        if let urlError = error as? URLError {
            switch urlError.code {
                case .notConnectedToInternet, .networkConnectionLost:
                    return "No hay conexión a Internet. Por favor, verifica tu conexión."
                case .timedOut:
                    return "La solicitud tardó demasiado. Intenta nuevamente."
                default:
                    return "Error de red: \(urlError.localizedDescription)"
            }
        } else if error is DecodingError {
            return "Error al procesar los datos. Intenta nuevamente más tarde."
        } else {
            return "Ocurrió un error inesperado: \(error.localizedDescription)"
        }
    }
    
    func addToCart(product: Product, quantity: Int) async {
        await cartManager.addToCart(product: product, quantity: quantity)
    }
}
