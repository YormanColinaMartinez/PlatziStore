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
    //MARK: - Properties -
    @Published var items: [CartItem] = []
    private var cancellables = Set<AnyCancellable>()
    var cartManager: CartManager
    
    //MARK: - Initializers -
    init(cartManager: CartManager) {
        self.cartManager = cartManager
        cartManager.$items
            .receive(on: RunLoop.main)
            .assign(to: \.items, on: self)
            .store(in: &cancellables)
    }
    
    //MARK: - Methods -
    func add(product: Product, quantity: Int) async {
        await cartManager.add(product: product, quantity: quantity)
    }
    
    func addToCart(product: Product, quantity: Int) async {
        await cartManager.addToCart(product: product, quantity: quantity)
    }
    
    func createNewItem(product: Product, quantity: Int) -> CartItem {
         cartManager.createNewItem(product: product, quantity: quantity)
    }
    
    func removeItem(_ item: CartItem) async {
        await cartManager.removeItem(item)
    }

    func updateQuantity(for item: CartItem, change: Int64) async {
        await cartManager.updateQuantity(for: item, change: change)
    }

    func totalAmount() -> Double {
        cartManager.totalAmount()
    }
    
    func checkout() async {
        await cartManager.checkout()
    }
}
