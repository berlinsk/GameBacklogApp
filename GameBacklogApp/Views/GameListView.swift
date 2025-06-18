//
//  GameListView.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 08.06.2025.
//

import SwiftUI

struct GameListView: View {
    @StateObject private var viewModel = GameListViewModel()
    @EnvironmentObject var appState: AppState
    @State private var selectedGame: Game?

    @ViewBuilder
    var content: some View {
        if viewModel.isLoading {
            ProgressView("Завантаження...")
        } else if let error = viewModel.errorMessage {
            Text("Помилка: \(error)")
                .foregroundColor(.red)
        } else {
            List {
                ForEach(viewModel.games) { game in
                    VStack(alignment: .leading) {
                        Text(game.title).font(.headline)
                        Text(game.platform).font(.subheadline)
                        Text("Жанри: \(game.genres.joined(separator: ", "))").font(.caption)
                        Text("Статус: \(game.status.rawValue.capitalized), Оцінка: \(game.rating)/10").font(.caption)
                    }.onTapGesture { selectedGame = game }
                }.onDelete(perform: viewModel.delete)
            }
        }
    }

    var body: some View {
        NavigationView {
            content
                .navigationTitle("Мої ігри")
                .onAppear { viewModel.loadGames() }
                .refreshable { viewModel.loadGames() }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Logout") {
                            appState.logout()
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            selectedGame = Game(
                                id: UUID(), title: "", platform: "", coverURL: nil,
                                status: .backlog, rating: 0, notes: "", genres: [],
                                createdAt: ISO8601DateFormatter().string(from: Date())
                            )
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(item: $selectedGame) { game in
                    NavigationStack {
                        EditGameView(game: game) { edited in
                            if viewModel.games.contains(where: { $0.id == edited.id }) {
                                viewModel.save(game: edited)
                            } else {
                                viewModel.add(game: edited)
                            }
                        }
                    }
                }
        }
        .environmentObject(appState)
    }
}
