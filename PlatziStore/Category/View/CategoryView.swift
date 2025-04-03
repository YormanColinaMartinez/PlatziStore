//
//  CategoryView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI

struct CategoryView: View {
    let model: CategoryModel?
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: model?.image ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 90, height: 90)
            }
            Text(model?.name ?? "")
        }
    }
}
