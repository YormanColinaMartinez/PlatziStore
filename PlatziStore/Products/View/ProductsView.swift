//
//  ProductsView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI
import CoreData

struct ProductsView: View {
    let context: NSManagedObjectContext
    @StateObject private var viewModel: ProductsViewModel
    @State private var searchText: String = ""
    @State private var selectedCategory: String? = nil
    @State private var isSearching: Bool = false
    @State private var selectedProduct: Product?
    @State private var showDetail = false

    var filteredItems: [Product] {
        viewModel.products.filter { product in
            let categoryName = product.categoryRelationship?.name ?? ""
            let title = product.title ?? ""
            let matchesCategory = selectedCategory == nil || categoryName == selectedCategory
            let matchesSearch = searchText.isEmpty || title.localizedCaseInsensitiveContains(searchText)
            return matchesCategory && matchesSearch
        }
    }

    var body: some View {
        NavigationView {
            VStack {
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
                                    .foregroundColor(.white)
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
                                .transition(.move(edge: .leading))
                                .animation(.easeInOut(duration: 0.5), value: isSearching)
                        }
                        
                        Spacer()

                        Button(action: {
                            if searchText.isEmpty {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    isSearching.toggle()
                                }
                            } else {
                                searchText = ""
                            }

                        }) {
                            Image(systemName: isSearching ? "x.circle" : "magnifyingglass")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                                .padding(10)
                        }
                    }
                    .padding(.horizontal)

                    Text(selectedCategory ?? "Explore our collection...")
                        .foregroundColor(.white)
                        .font(.system(size: isSearching ? 20 : 30 , weight: .bold))
                        .frame(width: .infinity, alignment: isSearching ? .leading : .center)
                    
                    if selectedCategory == nil && !isSearching {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 16) {
                                ForEach(viewModel.categories, id: \ .id) { item in
                                    CategoryView(model: item)
                                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 5, y: 5)
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
                        .background(.clear)
                    }
                }
                .background(Color("mainColorApp", bundle: nil))
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 20) {
                        ForEach(filteredItems, id: \ .id) { item in
                            ItemCellView(model: item)
                                .onTapGesture {
                                    selectedProduct = item
                                    showDetail = true
                                }
                        }
                    }
                    .padding()
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 0.5), value: selectedCategory)
                }
            }
            .fullScreenCover(item: $selectedProduct) { product in
                ProductDetailView(product: product)
            }
            .task {
                await viewModel.loadProducts()
                await viewModel.loadCategories()
            }.background(Color("mainColorApp", bundle: nil))
        } .navigationBarHidden(true)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        _viewModel = StateObject(wrappedValue: ProductsViewModel(context: context))
    }
}
