//
//  ItemCellView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI

struct ItemCellView: View {
    var model: ProductModel

    var body: some View {
        
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: model.images[0])) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(model.title)
                        .font(.headline)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Text(model.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)

                    HStack {
                        Text(String(model.price))
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.green)

                        Spacer()
                        Button {
                            print("")
                        } label: {
                            Text("Buy")
                        }
                        .frame(width: 50, height: 30)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8.0)
                    }
                }

                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}
