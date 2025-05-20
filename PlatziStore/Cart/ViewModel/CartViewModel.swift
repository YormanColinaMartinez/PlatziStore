//
//  CartViewModel.swift
//  PlatziStore
//
//  Created by mac on 10/04/25.
//

import SwiftUI
import CoreData

class CartViewModel: ObservableObject {
    var cartManager: CartManager
    
    var items: [CartItem] {
        return cartManager.items
    }
    
    init(cartManager: CartManager) {
        self.cartManager = cartManager
    }
        
    func fetchOnManager() {
        cartManager.fetchItems()
    }
    
    func add(product: Product, quantity: Int) {
        cartManager.add(product: product, quantity: quantity)
    }

    func addToCart(product: Product) {
        cartManager.addToCart(product: product)
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
