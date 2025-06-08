//
//  GameBacklogAppApp.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 08.06.2025.
//

import SwiftUI

@main
struct GameBacklogApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if let _ = appState.token {
                GameListView()
                    .environmentObject(appState)
            } else {
                NavigationView {
                    LoginView()
                }
                .environmentObject(appState)
            }
        }
    }
}
