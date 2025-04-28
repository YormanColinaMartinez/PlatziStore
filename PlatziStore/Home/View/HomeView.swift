//
//  HomeView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var manager: CartViewModel
    let accessToken: String
    
    init(accessToken: String) {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(named: "mainColorApp")
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().unselectedItemTintColor = UIColor.white.withAlphaComponent(0.6)
        _manager = StateObject(wrappedValue: CartViewModel(context: PersistenceController.shared.container.viewContext))
        self.accessToken = accessToken
    }

    var body: some View {
        TabView {
            ProductsView(manager: manager)
                .tabItem {
                    Label("Products", systemImage: "cart")
                }
            CartView(manager: manager)
                .tabItem {
                    Label("Cart", systemImage: "bag")
                }
            ProfileView(viewModel: ProfileViewModel(accessToken: accessToken))
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .accentColor(.white)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
