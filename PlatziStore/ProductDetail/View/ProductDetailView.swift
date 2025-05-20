//
//  ProductDetail.swift
//  PlatziStore
//
//  Created by mac on 3/04/25.
//

import SwiftUI

struct ProductDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var manager: CartManager
    @State private var itemQuantity: Int = 0
    private var product: Product
    private let itemWidth: CGFloat = 230

    init(product: Product) {
        self.product = product
    }

    var body: some View {
        VStack {
            Button(action: { dismiss() }, label: {
                Image(systemName: "xmark")
                    .resizable()
                    .foregroundColor(.white)
            })
            .position(x: -150, y: 10)
            .frame(width: 20, height: 20)
            .foregroundColor(.black)

            imageCarrousel.frame(height: itemWidth * 1.1)

            Spacer()

            VStack(alignment: .leading) {
                Text(product.title ?? .empty)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.leading)

                Text(product.productDescription ?? .empty)
                    .font(.body)
                    .foregroundStyle(.gray)
                    .padding()

                HStack {
                    Text("$\(product.price)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.leading)

                    Spacer()

                    HStack(spacing: 16) {
                        Button {
                            if self.itemQuantity > 0 {
                                self.itemQuantity -= 1
                            }
                        } label: {
                            Image(systemName: "minus.circle")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.3), radius: 2, x: -2, y: 2)
                        }
                        .frame(width: 30, height: 30)
                        .padding(.leading)

                        Text("\(itemQuantity)")
                            .foregroundColor(.white)

                        Button(action: { self.itemQuantity += 1 }, label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.3), radius: 2, x: -2, y: 2)
                        })
                        .frame(width: 40, height: 40)
                        .padding(.trailing)
                    }
                    .frame(height: 40)
                    .cornerRadius(12)
                    .padding(.trailing)
                }
            }
            .padding()

            Button {
                if itemQuantity > 0 {
                    manager.add(product: product, quantity: itemQuantity)
                }
                dismiss()
            } label: { Text(itemQuantity > 0 ? Strings.Detail.add.description : Strings.Detail.addToCart.description)
                + (itemQuantity > 0 ? Text("\(itemQuantity)").fontWeight(.heavy) + Text(Strings.Detail.toCart.description) : Text(verbatim: .empty))
            }
            .frame(width: 150, height: 40)
            .background(itemQuantity > 0 ? .green : .gray)
            .foregroundColor(itemQuantity > 0 ? .black : .white)
            .cornerRadius(14)
            .padding()
        }
        .background(Color(Strings.Colors.mainColorApp.rawValue, bundle: nil))
    }
    
    private var imageCarrousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(product.imagesArray.indices, id: \.self) { index in
                    GeometryReader { proxy in
                        let scale = getScale(proxy: proxy)

                        AsyncImage(url: URL(string: product.imagesArray[index])) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: itemWidth * scale, height: itemWidth * scale)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 5)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: itemWidth * scale, height: itemWidth * scale)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .animation(.easeInOut(duration: 0.3), value: scale)
                    }
                    .frame(width: itemWidth, height: itemWidth)
                }
            }
            .padding(.horizontal, 40)
        }
    }

    private func getScale(proxy: GeometryProxy) -> CGFloat {
        let midPoint = UIScreen.main.bounds.width / 2
        let viewMid = proxy.frame(in: .global).midX
        let distance = abs(midPoint - viewMid)
        let scale = max(1.0 - (distance / midPoint * 0.4), 0.85)
        return scale
    }
}
