//
//  CategoryView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI

struct CategoryView: View {
    let model: Category?
    
    var body: some View {
        VStack(alignment: .center) {
            AsyncImage(url: URL(string: model?.image ?? .empty)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 65, height: 65)
            }
            Text(model?.name ?? .empty)
                .foregroundColor(.white)
                .lineLimit(2)
                .font(.system(size: 12))
        }
    }
}
