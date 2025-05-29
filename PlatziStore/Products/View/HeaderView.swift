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
                    Image(systemName: Icons.arrowLeft.description)
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
                TextField(Products.search.description, text: $viewModel.searchText)
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
                Image(systemName: viewModel.isSearching ? Icons.xcircle.description : Icons.magnifyingGlass.description)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(10)
            }
        }
        .padding(viewModel.isSearching ? 20 : 0)
    }
    
    var titleView: some View {
        Group {
            Text(viewModel.selectedCategory != nil ? viewModel.selectedCategory ?? .empty : Products.explore.description)
                .font(.system(size: 24))
                .foregroundColor(.white)
            + Text(viewModel.selectedCategory != nil ? .empty : Products.collection.description)
                .font(.system(size: 40)).bold()
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: viewModel.selectedCategory != nil ? .center : .leading)
        .padding()
    }
}
