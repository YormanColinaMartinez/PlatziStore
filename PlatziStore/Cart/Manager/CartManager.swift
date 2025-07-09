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
            if product.managedObjectContext != self.context {
                print("⚠️ Product está en un contexto diferente")
                return
            }
            
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
    
    func checkout() async {
        guard !items.isEmpty else { return }

        await context.perform {
            let order = Order(context: self.context)
            order.id = self.nextOrderId()
            order.date = Date()
            order.totalAmount = Int64(self.totalAmount())

            for cartItem in self.items {
                let orderItem = OrderItem(context: self.context)
                cartItem.id = self.nextOrderItemId()
                orderItem.id = 1
                orderItem.name = cartItem.name
                orderItem.price = cartItem.price
                orderItem.quantity = cartItem.quantity
                orderItem.imageUrl = cartItem.imageUrl
                orderItem.productId = cartItem.productId
                orderItem.orderRelationship = order
            }

            for cartItem in self.items {
                self.context.delete(cartItem)
            }

            self.items.removeAll()
        }
        await saveContext()
    }
    
    func nextOrderId() -> Int64 {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        request.fetchLimit = 1

        if let lastOrder = try? context.fetch(request).first {
            return lastOrder.id + 1
        } else {
            return 1
        }
    }
    
    func nextOrderItemId() -> Int64 {
        let request: NSFetchRequest<OrderItem> = OrderItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        request.fetchLimit = 1

        if let lastItem = try? context.fetch(request).first {
            return lastItem.id + 1
        } else {
            return 1
        }
    }
    
    var totalItemsCount: Int {
        items.reduce(0) { $0 + Int($1.quantity) }
    }
}
