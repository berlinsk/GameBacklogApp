//
//  AppState.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 08.06.2025.
//

import Foundation

class AppState: ObservableObject {
    @Published var token: String? {
        didSet {
            if let token = token {
                UserDefaults.standard.set(token, forKey: "authToken")
            } else {
                UserDefaults.standard.removeObject(forKey: "authToken")
            }
        }
    }

    init() {
        self.token = UserDefaults.standard.string(forKey: "authToken")
    }

    func logout() {
        token = nil
    }
}
