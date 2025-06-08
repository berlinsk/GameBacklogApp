//
//  GameListView.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 08.06.2025.
//

import SwiftUI

struct GameListView: View {
    @StateObject private var viewModel = GameListViewModel()

    @ViewBuilder
    var content: some View {
        if viewModel.isLoading {
            ProgressView("Завантаження...")
        } else if let error = viewModel.errorMessage {
            Text("Помилка: \(error)")
                .foregroundColor(.red)
        } else {
            List(viewModel.games) { game in
                VStack(alignment: .leading) {
                    Text(game.title).font(.headline)
                    Text(game.platform).font(.subheadline)
                    Text("Жанри: \(game.genres.joined(separator: ", "))").font(.caption)
                    Text("Статус: \(game.status.rawValue.capitalized), Оцінка: \(game.rating)/10").font(.caption)
                }
            }
        }
    }

    var body: some View {
        NavigationView {
            content
                .navigationTitle("Мої ігри")
                .onAppear { viewModel.loadGames() }
                .refreshable { viewModel.loadGames() }
        }
    }
}
