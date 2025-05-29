//
//  CartTabIcon.swift
//  PlatziStore
//
//  Created by mac on 27/05/25.
//

import SwiftUI

struct CartTabIcon: View {
    let count: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(Icons.filledBasket.description)
                .resizable()
                .renderingMode(.template)
                .frame(width: 24, height: 24)
            
            if count > 0 {
                Text("\(count)")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .frame(minWidth: 16, minHeight: 16)
                    .background(Color.red)
                    .clipShape(Circle())
                    .offset(x: 8, y: -8)
                    .animation(.spring(), value: count)
            }
        }
        .frame(width: 24, height: 24)
    }
}
