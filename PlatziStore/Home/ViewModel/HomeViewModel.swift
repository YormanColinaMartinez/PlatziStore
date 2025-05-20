//
//  HomeViewModel.swift
//  PlatziStore
//
//  Created by mac on 20/05/25.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @EnvironmentObject private var cartManager: CartManager
    
    let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
}
