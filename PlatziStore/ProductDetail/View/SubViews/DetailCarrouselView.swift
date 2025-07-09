//
//  DetailCarrouselView.swift
//  PlatziStore
//
//  Created by mac on 4/06/25.
//

import SwiftUI

struct DetailCarrouselView: View {
    //MARK: - Properties -
    @ObservedObject var viewModel: ProductDetailViewModel
    
    //MARK: - Body -
    var body: some View {
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
    
    //MARK: - Methods -
    private func getScale(proxy: GeometryProxy) -> CGFloat {
        let midPoint = UIScreen.main.bounds.width / 2
        let viewMid = proxy.frame(in: .global).midX
        let distance = abs(midPoint - viewMid)
        let scale = max(1.0 - (distance / midPoint * 0.4), 0.85)
        return scale
    }
}
