//
//  TabBarViewModel.swift
//  PlatziStore
//
//  Created by mac on 20/05/25.
//

import SwiftUI

class TabBarViewModel: ObservableObject {
    @ObservedObject var sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    func saveToken(accessToken: String) {
        sessionManager.saveToken(accessToken: accessToken)
    }
    
    func getToken() -> String {
        return sessionManager.getToken() ?? .empty
    }
    
    func deleteToken() {
        sessionManager.deleteToken()
    }
}
