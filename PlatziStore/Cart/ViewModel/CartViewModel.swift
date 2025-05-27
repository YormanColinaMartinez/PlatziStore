//
//  CartViewModel.swift
//  PlatziStore
//
//  Created by mac on 10/04/25.
//

import SwiftUI
import CoreData
import Combine

class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = []
    @ObservedObject var cartManager: CartManager
    
    private var cancellables = Set<AnyCancellable>()

    init(cartManager: CartManager) {
        self.cartManager = cartManager
        cartManager.$items
            .receive(on: DispatchQueue.main)
            .assign(to: \.items, on: self)
            .store(in: &cancellables)
    }
    
    func add(product: Product, quantity: Int) {
        cartManager.add(product: product, quantity: quantity)
    }
    
    func addToCart(product: Product, quantity: Int) {
        cartManager.addToCart(product: product, quantity: quantity)
    }
    
    func createNewItem(product: Product, quantity: Int) -> CartItem {
        cartManager.createNewItem(product: product, quantity: quantity)
    }
    
    func removeItem(_ item: CartItem) {
        cartManager.removeItem(item)
    }

    func updateQuantity(for item: CartItem, change: Int64) {
        cartManager.updateQuantity(for: item, change: change)
    }

    func totalAmount() -> Double {
        cartManager.totalAmount()
    }
}
