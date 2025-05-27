//
//  PlatziStoreApp.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI
import CoreData

@main
struct PlatziStoreApp: App {
    private let persistenceController = PersistenceController.shared
    @StateObject private var cartManager: CartManager

    init() {
        let context = persistenceController.container.viewContext
        _cartManager = StateObject(wrappedValue: CartManager(context: context))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(cartManager)
        }
    }
}
