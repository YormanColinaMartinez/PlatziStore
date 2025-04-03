//
//  ProductsView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    @State private var searchText: String = ""
    @State private var selectedCategory: String? = nil
    @State private var isSearching: Bool = false
    @State private var selectedProduct: ProductModel?
    @State private var showDetail = false

    var filteredItems: [ProductModel] {
        if let category = selectedCategory {
            return viewModel.products.filter { $0.category.name == category }
        } else if searchText.isEmpty {
            return viewModel.products
        } else {
            return viewModel.products.filter { $0.title.contains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    if selectedCategory != nil {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                selectedCategory = nil
                            }
                        }) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.black)
                                .padding(10)
                        }
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 2.0), value: selectedCategory)
                    }
                    
                    if isSearching {
                        TextField("Search...", text: $searchText)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .transition(.move(edge: .top))
                            .animation(.easeInOut(duration: 0.5), value: isSearching)
                    }
                    
                    Spacer()

                    // 🔹 Botón de búsqueda (Lupa)
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isSearching.toggle()
                        }
                    }) {
                        Image(systemName: isSearching ? "x.circle" : "magnifyingglass")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                            .padding(10)
                    }
                }
                .padding(.horizontal)

                Text(selectedCategory ?? "Categories")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.top)

                if selectedCategory == nil {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(viewModel.categories, id: \ .id) { item in
                                CategoryView(model: item)
                                    .shadow(color: .black.opacity(0.3), radius: 8, x: 5, y: 5)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            selectedCategory = item.name
                                        }
                                    }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 150)
                    }
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 20) {
                        ForEach(filteredItems, id: \ .id) { item in
                            ItemCellView(model: item)
                                .onTapGesture {
                                    selectedProduct = item
                                    showDetail = true // 🔹 Abre la vista de detalle
                                }
                        }
                    }
                    .padding()
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 0.5), value: selectedCategory)
                }
            }
            .fullScreenCover(item: $selectedProduct) { product in
                CartView()
            }
            .task {
                await viewModel.loadProducts()
                await viewModel.loadCategories()
            }
        }
    }
}
