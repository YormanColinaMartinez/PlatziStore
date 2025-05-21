//
//  CartManager.swift
//  PlatziStore
//
//  Created by mac on 20/05/25.
//

import SwiftUI
import CoreData
import Combine

class CartManager: ObservableObject {
    @Published var items: [CartItem] = []
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchItems()
    }
    
    private func saveContext() {
        do {
            try context.save()
            fetchItems()
        } catch {
            print("❌ Error al guardar cambios del carrito: \(error)")
        }
    }
    
    func add(product: Product, quantity: Int) {
        guard quantity > 0 else { return }

        if let existingItem = items.first(where: { $0.productId == product.id }) {
            existingItem.quantity += Int64(quantity)
        } else {
            items.append(createNewItem(product: product, quantity: quantity))
        }
        saveContext()
    }
    
    func addToCart(product: Product, quantity: Int) {
        if let existingItem = items.first(where: { $0.productId == product.id }) {
            existingItem.quantity += 1
        } else {
            items.append(createNewItem(product: product, quantity: quantity))
        }
        saveContext()
    }
    
    func createNewItem(product: Product, quantity: Int) -> CartItem {
        let newItem = CartItem(context: context)
        newItem.id = product.id
        newItem.productId = product.id
        newItem.name = product.title
        newItem.price = product.price
        newItem.quantity = Int64(quantity)
        newItem.imageUrl = product.imagesArray.first ?? .empty
        
        return newItem
    }
    
    func fetchItems() {
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        do {
            items = try context.fetch(request)
        } catch {
            print("❌ Error al cargar el carrito: \(error)")
        }
    }
    
    func removeItem(_ item: CartItem) {
        context.delete(item)
        saveContext()
    }

    func updateQuantity(for item: CartItem, change: Int64) {
        item.quantity += Int64(change)
        if item.quantity <= 0 {
            removeItem(item)
        } else {
            saveContext()
        }
    }

    func totalAmount() -> Double {
        items.reduce(0) { $0 + (Double($1.quantity) * Double($1.price)) }
    }
}
