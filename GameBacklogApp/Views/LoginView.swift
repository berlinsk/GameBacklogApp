//
//  LoginView.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 08.06.2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 20) {
            Picker("Mode", selection: $viewModel.mode) {
                Text("Login").tag(AuthMode.login)
                Text("Register").tag(AuthMode.register)
            }
            .pickerStyle(.segmented)
            
            TextField("Login", text: $viewModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            }

            Button(viewModel.mode == .login ? "Enter" : "Register") {
                viewModel.submit { token in
                    if let token = token {
                        appState.token = token
                    }
                }
            }
            .disabled(viewModel.isLoading)

            if viewModel.isLoading {
                ProgressView()
            }
        }
        .padding()
        .navigationTitle(viewModel.mode == .login ? "Authorization" : "Registration")
    }
}
