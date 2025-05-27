//
//  ContentView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var sessionManager = SessionManager()
    @State private var showSplashScreen = true
    
    var body: some View {
        Group {
            if showSplashScreen {
                SplashView()
                    .transition(.opacity)
            } else {
                if sessionManager.isLoggedIn {
                    TabBarView(sessionManager: sessionManager)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)))
                } else {
                    LoginView(viewModel: LoginViewModel(sessionManager: sessionManager))
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: sessionManager.isLoggedIn)
        .task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            withAnimation {
                showSplashScreen = false
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
