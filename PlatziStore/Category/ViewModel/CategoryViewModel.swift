//
//  CategoryViewModel.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import Foundation

class CategoryViewModel {
    @Published var categories: [CategoryModel] = []
    var service: CategoryInterface
    
    init(service: CategoryInterface) {
        self.service = service
    }
    
    func loadCategories() async {
        do {
            let fetchedCategories = try await service.fetchCategories(url: "https://api.escuelajs.co/api/v1/categories")
            self.categories = fetchedCategories
        } catch {
            print("Error al cargar categorías:", error)
        }
    }
}
