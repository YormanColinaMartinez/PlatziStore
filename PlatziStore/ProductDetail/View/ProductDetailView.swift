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
            
            imageCarrousel.frame(height: viewModel.itemWidth * 1.1)

            Spacer()
            
            DetailContentView(viewModel: viewModel)
            
            checkoutButton
        }
        .background(Colors.mainColorApp.color)
    }
    
    //MARK: - Subviews -
    private var imageCarrousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.product.imagesArray.indices, id: \.self) { index in
                    GeometryReader { proxy in
                        let scale = getScale(proxy: proxy)

                        AsyncImage(url: URL(string: viewModel.product.imagesArray[index])) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: viewModel.itemWidth * scale, height: viewModel.itemWidth * scale)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 5)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: viewModel.itemWidth * scale, height: viewModel.itemWidth * scale)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .animation(.easeInOut(duration: 0.3), value: scale)
                    }
                    .frame(width: viewModel.itemWidth, height: viewModel.itemWidth)
                }
            }
            .padding(.horizontal, 40)
        }
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
    
    @ViewBuilder private var checkoutButton: some View {
        Button {
            if viewModel.itemQuantity > 0 {
                viewModel.cartManager.add(product: viewModel.product, quantity: viewModel.itemQuantity)
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

    //MARK: - Methods -
    private func getScale(proxy: GeometryProxy) -> CGFloat {
        let midPoint = UIScreen.main.bounds.width / 2
        let viewMid = proxy.frame(in: .global).midX
        let distance = abs(midPoint - viewMid)
        let scale = max(1.0 - (distance / midPoint * 0.4), 0.85)
        return scale
    }
}
