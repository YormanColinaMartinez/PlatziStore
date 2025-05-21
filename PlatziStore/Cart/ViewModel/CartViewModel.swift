//
//  CartViewModel.swift
//  PlatziStore
//
//  Created by mac on 10/04/25.
//

import SwiftUI
import CoreData

class CartViewModel: ObservableObject {
    @ObservedObject var cartManager: CartManager
    

    
    init(cartManager: CartManager) {
        self.cartManager = cartManager
    }
        

}
