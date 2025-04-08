//
//  ItemCellView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI

struct ItemCellView: View {
    var model: Product

    var body: some View {
        
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: model.imagesArray.first ?? "")) { image in
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
                    Text(model.title ?? "")
                        .font(.headline)
                        .lineLimit(3)
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
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color.white.opacity(0.5))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}
