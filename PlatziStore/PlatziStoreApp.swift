//
//  PlatziStoreApp.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI

@main
struct PlatziStoreApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
