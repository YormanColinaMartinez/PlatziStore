//
//  CartView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI
import CoreData

struct CartView: View {
    @StateObject private var cartManager: CartViewModel
    
    init(manager: CartViewModel) {
        _cartManager = StateObject(wrappedValue: manager)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Text("My Cart")
                    .frame(width: .infinity)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding()
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(cartManager.items, id: \.id) { item in
                        HStack(spacing: 16) {
                            AsyncImage(url: URL(string: item.imageUrl ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.name ?? "")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("$\(item.price)")
                                    .foregroundColor(.green)
                            }
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Button(action: {
                                    cartManager.updateQuantity(for: item, change: -1)
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
                                    cartManager.updateQuantity(for: item, change: 1)
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
            
            VStack(spacing: 16) {
                HStack {
                    Text("Total")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text("$\(cartManager.totalAmount(), specifier: "%.2f")")
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
}
