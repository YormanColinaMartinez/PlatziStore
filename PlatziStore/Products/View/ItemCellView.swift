//
//  ItemCellView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI

struct ItemCellView: View {
    var model: Product
    @ObservedObject var manager: CartViewModel
    @State private var imageFailedToLoad = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: model.imagesArray.first ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(12)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 120)
                    .cornerRadius(12)
            }
            .frame(width: 120)

            Text(model.title ?? "")
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(2)

            Text(model.productDescription ?? "")
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(2)

            HStack {
                Text("$\(model.price)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)

                Spacer()

                Button(action: {
                    manager.addToCart(product: model)
                }) {
                    Image(systemName: "cart.badge.plus")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.green)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
