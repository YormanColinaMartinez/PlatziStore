//
//  HomeView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI
import CoreData
import UIKit

struct HomeView: View {
    @EnvironmentObject var cartManager: CartManager
    @StateObject private var viewModel: HomeViewModel

    init(accessToken: String) {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(named: "mainColorApp")
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().unselectedItemTintColor = UIColor.white.withAlphaComponent(0.6)
        
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 100)
        _viewModel = StateObject(wrappedValue: HomeViewModel(accessToken: accessToken))
    }

    var body: some View {
        TabView {
            ProductsView(viewModel: ProductsViewModel(cartManager: cartManager))
                .tabItem {
                    Label("Products", systemImage: "cart")
                }
            CartView(viewModel: CartViewModel(cartManager: cartManager))
                .tabItem {
                    Label("Cart", systemImage: "bag")
                }
            ProfileView(viewModel: ProfileViewModel(accessToken: viewModel.accessToken))
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .accentColor(.white)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
