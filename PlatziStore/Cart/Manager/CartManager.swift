//
//  CartManager.swift
//  PlatziStore
//
//  Created by mac on 20/05/25.
//

import SwiftUI
import CoreData

class CartManager: ObservableObject {
    
    //MARK: - Properties -
    @Published var items: [CartItem] = []
    fileprivate let context: NSManagedObjectContext
    
    //MARK: - Initializers -
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //MARK: - Fileprivate Methods -
    fileprivate func saveContext() async {
        do {
            try await context.perform {
                try self.context.save()
            }
            await fetchItems()
        } catch {
            print("❌ Error al guardar cambios del carrito: \(error)")
        }
    }
    
    fileprivate func fetchItems() async {
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        do {
            try await context.perform {
                self.items = try self.context.fetch(request)
            }
        } catch {
            print("❌ Error al cargar el carrito: \(error)")
        }
    }
}


//MARK: - Extension CartManager -
extension CartManager {
    
    func initialize() async {
        await fetchItems()
    }
    
    func add(product: Product, quantity: Int) async {
        guard quantity > 0 else { return }

        await context.perform {
            if let existingItem = self.items.first(where: { $0.productId == product.id }) {
                existingItem.quantity += Int64(quantity)
            } else {
                _ = self.createNewItem(product: product, quantity: quantity)
            }
        }
        await saveContext()
    }
    
    func addToCart(product: Product, quantity: Int) async  {
        guard context.persistentStoreCoordinator != nil else {
            print("⚠️ Error: Carrito no disponible (contexto inválido)")
            return
        }

        await context.perform {
            if let existingItem = self.items.first(where: { $0.productId == product.id }) {
                existingItem.quantity += Int64(quantity)
            } else {
                _ = self.createNewItem(product: product, quantity: quantity)
            }
        }
        await self.saveContext()
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
    
    func removeItem(_ item: CartItem) async {
        await context.perform {
            self.context.delete(item)
        }
        await self.saveContext()
    }

    func updateQuantity(for item: CartItem, change: Int64) async {
        item.quantity += Int64(change)
        if item.quantity <= 0 {
           await removeItem(item)
        } else {
            await saveContext()
        }
    }

    func totalAmount() -> Double {
        items.reduce(0) { $0 + (Double($1.quantity) * Double($1.price)) }
    }
    
    var totalItemsCount: Int {
        items.reduce(0) { $0 + Int($1.quantity) }
    }
}
