//
//  LoginViewModel.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 08.06.2025.
//

import Foundation

enum AuthMode { case login, register }

class LoginViewModel: ObservableObject {
    @Published var mode: AuthMode = .login
    @Published var username = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoading = false

    func login(completion: @escaping (String?) -> Void) {
        isLoading = true
        errorMessage = nil

        APIService.shared.login(username: username, password: password) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let token):
                    completion(token)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    completion(nil)
                }
            }
        }
    }
    
    func submit(completion: @escaping (String?) -> Void) {
        isLoading = true
        errorMessage = nil

        let handler: (Result<String,Error>) -> Void = { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let token):
                    completion(token)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(nil)
                }
            }
        }

        switch mode {
        case .login:
            APIService.shared.login(username: username, password: password, completion: handler)
        case .register:
            APIService.shared.register(username: username, password: password, completion: handler)
        }
    }
}
