//
//  ProductDetailViewModel.swift
//  PlatziStore
//
//  Created by mac on 21/05/25.
//

import Foundation

class ProductDetailViewModel: ObservableObject {
    @Published var itemQuantity: Int = 0
    @Published var product: Product
    var cartManager: CartManager
    let itemWidth: CGFloat = 230
    
    init(cartManager: CartManager, product: Product) {
        self.cartManager = cartManager
        self.product = product
    }
}
