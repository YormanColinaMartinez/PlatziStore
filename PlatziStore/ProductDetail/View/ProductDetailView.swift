//
//  ProductDetail.swift
//  PlatziStore
//
//  Created by mac on 3/04/25.
//

import SwiftUI

struct ProductDetailView: View {
    //MARK: - Properties -
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: ProductDetailViewModel
     
    //MARK: - Body -
    var body: some View {
        VStack {
            dismissButon
            
            DetailCarrouselView(viewModel: viewModel).frame(height: viewModel.itemWidth * 1.1)

            Spacer()
            
            DetailContentView(viewModel: viewModel)
            
            checkoutButton
        }
        .background(Colors.mainColorApp.color)
    }
    
    //MARK: - Subviews -
    @ViewBuilder private var checkoutButton: some View {
        Button {
            if viewModel.itemQuantity > 0 {
                Task {
                    await viewModel.cartManager.add(product: viewModel.product, quantity: viewModel.itemQuantity)
                }
            }
            dismiss()
        } label: { Text(viewModel.itemQuantity > 0 ? Detail.add.description : Detail.addToCart.description)
            + (viewModel.itemQuantity > 0 ? Text(" \(viewModel.itemQuantity) ").fontWeight(.heavy) + Text(Detail.toCart.description) : Text(verbatim: .empty))
        }
        .frame(width: 150, height: 40)
        .background(viewModel.itemQuantity > 0 ? .green : .gray)
        .foregroundColor(viewModel.itemQuantity > 0 ? .black : .white)
        .cornerRadius(14)
        .padding()
    }
    
    private var dismissButon: some View {
        Button(action: { dismiss() }, label: {
            Image(systemName: "xmark")
                .resizable()
                .foregroundColor(.white)
        })
        .position(x: -150, y: 10)
        .frame(width: 20, height: 20)
        .foregroundColor(.black)
    }
}
