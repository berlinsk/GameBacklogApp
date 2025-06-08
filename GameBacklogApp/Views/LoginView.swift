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
            TextField("Логін", text: $viewModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Пароль", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            }

            Button("Увійти") {
                viewModel.login { token in
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
        .navigationTitle("Авторизація")
    }
}
