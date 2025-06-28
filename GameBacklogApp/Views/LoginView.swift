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
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            VStack(spacing: 20) {
                Text(viewModel.mode == .login ? "Login" : "Register")
                    .retroTitle()

                HStack(spacing: 0) {
                    ForEach([AuthMode.login, AuthMode.register], id: \.self) { mode in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.mode = mode
                            }
                        }) {
                            Text(mode == .login ? "Login" : "Register")
                                .font(Theme.Fonts.subtitle())
                                .foregroundColor(viewModel.mode == mode ? Theme.Colors.accent : Theme.Colors.softText)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(
                                    ZStack {
                                        if viewModel.mode == mode {
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Theme.Colors.accent, lineWidth: 2)
                                                .background(
                                                    Theme.Colors.accent.opacity(0.15)
                                                        .cornerRadius(8)
                                                )
                                        }
                                    }
                                )
                        }
                    }
                }
                .frame(height: 40)
                .background(Theme.Colors.card)
                .cornerRadius(8)

                TextField("Login", text: $viewModel.username)
                    .font(Theme.Fonts.body())
                    .padding()
                    .background(Theme.Colors.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Theme.Colors.accent.opacity(0.3), lineWidth: 1)
                    )
                    .cornerRadius(8)

                SecureField("Password", text: $viewModel.password)
                    .font(Theme.Fonts.body())
                    .padding()
                    .background(Theme.Colors.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Theme.Colors.accent.opacity(0.3), lineWidth: 1)
                    )
                    .cornerRadius(8)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(Theme.Fonts.caption())
                        .foregroundColor(Theme.Colors.errorRed)
                }

                Button(viewModel.mode == .login ? "Enter" : "Register") {
                    viewModel.submit { token in
                        if let token = token {
                            appState.token = token
                        }
                    }
                }
                .buttonStyle(NeonButtonStyle())
                .disabled(viewModel.isLoading)

                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }

}
