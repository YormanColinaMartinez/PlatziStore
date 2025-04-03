//
//  HomeView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        TabView {
            ProductsView()
                .tabItem {
                    Label("Products", systemImage: "cart")
                }
            CartView()
                .tabItem {
                    Label("Orders", systemImage: "bag")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}
