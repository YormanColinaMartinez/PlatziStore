//
//  ProductViewModel.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import Foundation

class ProductsViewModel: ObservableObject {
    @Published var products: [ProductModel] = []
    @Published var categories: [CategoryModel] = []
    
    private let productService: ProductServiceInterface
    
    init(productService: ProductServiceInterface = ProductService()) {
        self.productService = productService
    }
    
    @MainActor
    func loadProducts() async {
        do {
            let fetchedProducts = try await productService.fetchProducts(url: "https://api.escuelajs.co/api/v1/products")
            self.products = fetchedProducts
        } catch {
            print("Error al cargar productos:", error)
        }
    }
}
