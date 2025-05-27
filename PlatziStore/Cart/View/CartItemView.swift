//
//  CartItemView.swift
//  PlatziStore
//
//  Created by mac on 21/05/25.
//

import SwiftUI
import Combine

struct CartItemView: View {
    
    //MARK: - Properties -
    @StateObject var viewModel: CartViewModel
    var item: CartItem
    
    //MARK: - Body -
    var body: some View {
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
                    print(item.quantity)
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
