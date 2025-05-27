//
//  CartView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI
import CoreData

struct CartView: View {
    
    //MARK: - Properties -
    @ObservedObject var viewModel: CartViewModel
    
    //MARK: - Body -
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Text("Cart")
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding()
            
            contentView
            checkoutView
        }
        .background(Color("mainColorApp", bundle: nil))
    }
    
    //MARK: - Subviews -
    var contentView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(viewModel.items, id: \.objectID) { item in
                    CartItemView(viewModel: viewModel, item: item)
                }
            }
            .padding(.top)
            .padding(.bottom, 30)
        }
    }
    
    var checkoutView: some View {
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
                    .background(viewModel.items.count > 0 ? .green : .gray)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
        }
        .padding(.top)
        .padding(.bottom, 30)
    }
}
