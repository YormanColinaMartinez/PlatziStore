//
//  ItemCellView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI

struct ItemCellView: View {
    
    //MARK: - Properties -
    @State private var imageFailedToLoad = false
    var model: Product
    var manager: CartManager

    //MARK: - Body -
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            AsyncImage(url: URL(string: model.imagesArray.first ?? .empty)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 110)
                    .clipped()
                    .cornerRadius(12)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 110)
                    .cornerRadius(12)
            }
            .frame(maxWidth: .infinity, maxHeight: 120)

            Text(model.title ?? .empty)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .lineLimit(2)

            Text(model.productDescription ?? .empty)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            Spacer()
            
            HStack {
                Text("$\(model.price)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Spacer()

                Button(action: {
                    manager.addToCart(product: model, quantity: 1)
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .padding(8)
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
        }
        .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
