//
//  HeaderView.swift
//  PlatziStore
//
//  Created by mac on 22/05/25.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var viewModel: ProductsViewModel
    
    var body: some View {
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
