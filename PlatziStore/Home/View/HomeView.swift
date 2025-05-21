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
                                VStack {
                                    Image("filled_home")
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 24, height: 24)
                                    Text("Products")
                                        .font(.system(size: 12))
                                }
                            }
            CartView(viewModel: CartViewModel(cartManager: cartManager))
                .tabItem {
                    VStack {
                        Image("filled_basket")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                        Text("Products")
                            .font(.system(size: 12))
                    }
                }
            ProfileView(viewModel: ProfileViewModel(accessToken: viewModel.accessToken))
                .tabItem {
                    VStack {
                        Image("filled_people_profile")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                        Text("Products")
                            .font(.system(size: 12))
                    }
                }
        }
        .accentColor(.white)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
