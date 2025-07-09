//
//  TabBarView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI
import CoreData
import UIKit

struct TabBarView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject var cartManager: CartManager
    @ObservedObject private var viewModel: TabBarViewModel

    init(sessionManager: SessionManager) {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(named: Colors.mainColorApp.rawValue)
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().unselectedItemTintColor = UIColor.white.withAlphaComponent(0.6)
        
        viewModel = TabBarViewModel(sessionManager: sessionManager)
    }

    var body: some View {
        TabView {
            ProductsView(viewModel: ProductsViewModel(cartManager: cartManager, context: context))
                .tabItem {
                    VStack {
                        Image(Icons.filledHome.description)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                        Text(Products.products.description)
                            .font(.system(size: 12))
                    }
                }
            CartView(viewModel: CartViewModel(cartManager: cartManager))
                .tabItem {
                    VStack {
                        Image(Icons.filledBasket.description)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                        Text(Cart.cart.description)
                            .font(.system(size: 12))
                    }
                }
                .badge(cartManager.totalItemsCount)
            ProfileView(viewModel: ProfileViewModel(sessionManager: viewModel.sessionManager, context: context))
                .tabItem {
                    VStack {
                        Image(Icons.filledPeople.description)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                        Text(Profile.profile.description)
                            .font(.system(size: 12))
                    }
                }
        }
        .accentColor(.white)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
