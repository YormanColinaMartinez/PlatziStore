//
//  ProductsView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI
import CoreData

struct ProductsView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject var viewModel: ProductsViewModel

    var filteredItems: [Product] {
        viewModel.products.filter { product in
            let categoryName = product.categoryRelationship?.name ?? .empty
            let title = product.title ?? .empty
            let matchesCategory = viewModel.selectedCategory == nil || categoryName == viewModel.selectedCategory
            let matchesSearch = viewModel.searchText.isEmpty || title.localizedCaseInsensitiveContains(viewModel.searchText)
            return matchesCategory && matchesSearch
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    searchSection
                    categorySection
                }.padding(.vertical)
                 .background(Color(Strings.Colors.mainColorApp.description, bundle: nil))
                
                productsSection
            }
        
            .background(Color(Strings.Colors.mainColorApp.description, bundle: nil))
            .navigationBarHidden(true)
            .fullScreenCover(item: $viewModel.selectedProduct) { product in
                ProductDetailView(product: product)
            }
            .task {
                await viewModel.loadProducts(context: context)
                await viewModel.loadCategories(context: context)
            }
        }
    }
    
    func isValidURL(_ urlString: String?) -> Bool {
        guard let urlString = urlString,
              let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url),
              !urlString.contains("imgur.com/removed") else {
            return false
        }
        return true
    }
    
    @ViewBuilder var searchSection: some View {
        HStack {
            if viewModel.selectedCategory != nil {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewModel.selectedCategory = nil
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
                .animation(.easeInOut(duration: 2.0), value: viewModel.selectedCategory)
            }
            
            if viewModel.isSearching {
                TextField("Search...", text: $viewModel.searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut(duration: 0.5), value: viewModel.isSearching)
            }
            
            Spacer()
            
            if !viewModel.isSearching {
                titleView
            }
            
            Button(action: {
                if viewModel.searchText.isEmpty {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewModel.isSearching.toggle()
                    }
                } else {
                    viewModel.searchText = .empty
                }

            }) {
                Image(systemName: viewModel.isSearching ? "x.circle" : "magnifyingglass")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(10)
            }
        }
        .padding(.horizontal)
        
    }

    @ViewBuilder var categorySection: some View {
        if viewModel.selectedCategory == nil && !viewModel.isSearching {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.categories, id: \ .id) { item in
                        CategoryView(model: item)
                            .frame(maxWidth: 65)
                            .shadow(color: Color.black.opacity(0.3), radius: 8, x: 5, y: 5)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    viewModel.selectedCategory = item.name
                                }
                            }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 100)
            }
        }
    }
    
    @ViewBuilder var productsSection: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(filteredItems.filter { isValidURL($0.imagesArray.first) }, id: \.id) { item in
                    ItemCellView(model: item)
                        .onTapGesture {
                            viewModel.selectedProduct = item
                            viewModel.showDetail = true
                        }
                }
            }
            .padding()
        }
    }
    
    var titleView: some View {
        Group {
            Text(viewModel.selectedCategory != nil ? viewModel.selectedCategory ?? "" : "Explore our\n")
                .font(.system(size: 24))
                .foregroundColor(.white)
            + Text(viewModel.selectedCategory != nil ? "" : "Collection")
                .font(.system(size: 40)).bold()
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: viewModel.selectedCategory != nil ? .center : .leading)
        .padding()
    }
}
