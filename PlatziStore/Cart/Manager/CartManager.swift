//
//  CartManager.swift
//  PlatziStore
//
//  Created by mac on 20/05/25.
//

import SwiftUI
import CoreData

class CartManager: ObservableObject {
    let context: NSManagedObjectContext
    @Published var items: [CartItem] = []
    
    init(context: NSManagedObjectContext) {
        self.context = context
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
            let newItem = CartItem(context: context)
            newItem.id = product.id
            newItem.productId = product.id
            newItem.name = product.title ?? .empty
            newItem.price = product.price
            newItem.quantity = Int64(quantity)
            newItem.imageUrl = product.imagesArray.first ?? .empty
            items.append(newItem)
        }
        saveContext()
    }
    
    func addToCart(product: Product) {
        if let existingItem = items.first(where: { $0.productId == product.id }) {
            existingItem.quantity += 1
        } else {
            let newItem = CartItem(context: context)
            newItem.id = product.id
            newItem.productId = product.id
            newItem.name = product.title
            newItem.price = product.price
            newItem.quantity = 1
            newItem.imageUrl = product.imagesArray.first ?? .empty
            items.append(newItem)
        }
        saveContext()
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
