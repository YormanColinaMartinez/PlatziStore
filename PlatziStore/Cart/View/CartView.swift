//
//  CartView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI
import CoreData

struct CartView: View {
    @StateObject var viewModel: CartViewModel
    
    init(viewModel: CartViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
        
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Text("My Cart")
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding()
            
            contentView
            
            VStack(spacing: 16) {
                HStack {
                    Text("Total")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text("$\(viewModel.totalAmount(), specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                .padding(.horizontal)
                
                Button(action: {
                }) {
                    Text("Checkout")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
            }
            .padding(.top)
            .padding(.bottom, 30)
        }
        .background(Color("mainColorApp", bundle: nil))
    }
    
    @ViewBuilder var contentView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(viewModel.items, id: \.id) { item in
                    HStack(spacing: 16) {
                        AsyncImage(url: URL(string: item.imageUrl ?? .empty)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.gray.opacity(0.2)
                        }
                        .frame(width: 80, height: 80)
                        .cornerRadius(10)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.name ?? .empty)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("$\(item.price)")
                                .foregroundColor(.green)
                        }
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Button(action: {
                                viewModel.updateQuantity(for: item, change: -1)
                            }) {
                                Image(systemName: "minus")
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .background(Color.gray)
                                    .clipShape(Circle())
                            }
                            
                            Text("\(item.quantity)")
                                .foregroundColor(.white)
                            
                            Button(action: {
                                viewModel.updateQuantity(for: item, change: 1)
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .background(Color.gray)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding()
                    .background(Color("mainColorApp", bundle: nil).opacity(0.2))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
    }
}
