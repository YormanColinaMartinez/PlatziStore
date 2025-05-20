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
    let persistenceController = PersistenceController.shared
    @StateObject var cartManager: CartManager = CartManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(cartManager)
        }
    }
}
