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

    let productService: ProductServiceInterface
    let categoryService: CategoryInterface

    init(productService: ProductServiceInterface = ProductService(), categoryService: CategoryInterface = CategoryService()) {
        self.productService = productService
        self.categoryService = categoryService
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

    @MainActor
    func loadCategories() async {
        do {
            let fetchedCategories = try await categoryService.fetchCategories(url: "https://api.escuelajs.co/api/v1/categories")
            self.categories = fetchedCategories
        } catch {
            print("Error al cargar categorías:", error)
        }
    }
}
