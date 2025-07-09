//
//  DetailContentView.swift
//  PlatziStore
//
//  Created by mac on 22/05/25.
//

import SwiftUI

struct DetailContentView: View {
    //MARK: - Properties -
    @ObservedObject var viewModel: ProductDetailViewModel
    
    //MARK: - Body -
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.product.title ?? .empty)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.leading)

            Text(viewModel.product.productDescription ?? .empty)
                .font(.body)
                .foregroundStyle(.gray)
                .padding()

            HStack {
                Text("$\(viewModel.product.price)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.leading)

                Spacer()

                HStack(spacing: 16) {
                    Button {
                        if self.viewModel.itemQuantity > 0 {
                            self.viewModel.itemQuantity -= 1
                        }
                    } label: {
                        Image(systemName: Icons.minusCircle.description)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.3), radius: 2, x: -2, y: 2)
                    }
                    .frame(width: 30, height: 30)
                    .padding(.leading)

                    Text("\(viewModel.itemQuantity)")
                        .foregroundColor(.white)

                    Button(action: { self.viewModel.itemQuantity += 1 }, label: {
                        Image(systemName: Icons.plusCircle.description)
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
    }
}
