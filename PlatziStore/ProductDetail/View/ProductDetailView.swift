//
//  ProductDetail.swift
//  PlatziStore
//
//  Created by mac on 3/04/25.
//

import SwiftUI

struct ProductDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var product: ProductModel
    @State private var selectedIndex: Int = 0
    @State private var scrollOffSet: CGFloat = 0.0
    private let itemWidth: CGFloat = 230
    
    var body: some View {
        Button(action: {dismiss()},
               label: {
            Image(systemName: "xmark")
                .resizable()
        })
        .position(x: -150, y: 10)
        .frame(width: 20, height: 20)
        .foregroundColor(.black)
        
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(product.images.indices, id: \.self) { index in
                        GeometryReader { proxy in
                            let scale = getScale(proxy: proxy)
                            
                            AsyncImage(url: URL(string: product.images[index])) { image in
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
            .frame(height: itemWidth * 1.1)
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text(product.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading)
                
                Text(product.description)
                    .font(.body)
                    .foregroundStyle(.gray)
                    .padding()
                
                HStack {
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .padding(.leading)
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button {} label: {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.3),radius: 0, x: -1, y: 1)
                        }
                        .frame(width: 30, height: 30)
                        .padding(.leading)
                        
                        Text("\(0)")
                        
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                                .background(Color.black)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.3),radius: 0, x: -1, y: 1)
                        })
                        .frame(width: 40, height: 40)
                        .padding(.trailing)
                    }
                    .background(.white)
                    .frame(height: 40)
                    .cornerRadius(12)
                    .padding(.trailing)
                }
            }
            .padding()
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
