//
//  ProductsView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI

struct ProductsView: View {
    @State private var selectedCategory: String? = nil
    @State private var isSearching: Bool = false
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    if selectedCategory != nil {
                        Button {
                            withAnimation(.easeInOut(duration: 0.5))  {
                                selectedCategory = nil
                            }
                        } label: {
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
                }.padding(.horizontal)
                
                Text(selectedCategory ?? "Categories")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.top)
                

            }
        }
    }
}
