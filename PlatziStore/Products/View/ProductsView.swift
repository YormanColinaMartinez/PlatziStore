//
//  ProductsView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI
import CoreData

struct ProductsView: View {
    
    //MARK: - Properties -
    @StateObject var viewModel: ProductsViewModel

    //MARK: - Body -
    var body: some View {
        VStack(spacing: 16) {
            HeaderView(viewModel: viewModel)
            categorySection
            productsSection
        }
        .padding(.vertical)
        .background(Colors.mainColorApp.color)
        .navigationBarHidden(true)
        .fullScreenCover(item: $viewModel.selectedProduct) { product in
            ProductDetailView(viewModel: ProductDetailViewModel(cartManager: viewModel.cartManager, product: product))
        }
        .alert(Products.error.description, isPresented: $viewModel.showErrorAlert) {
            Button(Products.ok.description, role: .cancel) {
                viewModel.showErrorAlert = false
            }
            Button(Products.retry.description) {
                Task {
                    await viewModel.loadProducts()
                }
            }
        } message: {
            Text(viewModel.errorMessage ?? Products.unknowError.description)
        }
        .task {

        }
    }
     
    //MARK: - Subviews -
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
                ForEach(viewModel.filteredItems.filter { image in
                    guard let url = image.imagesArray.first else { return false }
                    return viewModel.isValidURL(url)
                }, id: \.id) { item in
                    ItemCellView(viewModel: viewModel, model: item)
                        .onTapGesture {
                            viewModel.selectedProduct = item
                            viewModel.showDetail = true
                        }
                }
            }
            .padding()
        }
    }
}
