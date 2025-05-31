//
//  OrdersViewModel.swift
//  PlatziStore
//
//  Created by mac on 29/05/25.
//

import SwiftUI
import CoreData

@MainActor
class OrdersViewModel: ObservableObject {
    @Published var orders: [Order] = []
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchOrders() async {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Order.date, ascending: false)]

        do {
            try await context.perform {
                self.orders = try self.context.fetch(request)
            }
        } catch {
            print("❌ Error al cargar las órdenes: \(error)")
        }
    }
}
