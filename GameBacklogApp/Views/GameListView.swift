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
    @State private var detailGame: Game?
    @State private var editingGame: Game?

    @ViewBuilder
    var content: some View {
        if viewModel.isLoading {
            ProgressView("Loading...")
        } else if let error = viewModel.errorMessage {
            Text("Ooops: \(error)")
                .foregroundColor(.red)
        } else {
            List {
                ForEach(viewModel.filteredGames) { game in
                    HStack(alignment: .top, spacing: 12) {
                        if let urlString = game.coverURL,
                           let url = URL(string: urlString) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 60, height: 60)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .clipped()
                                        .cornerRadius(8)
                                case .failure:
                                    Color.gray
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(8)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Color.gray
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(game.title).font(.headline)
                            Text(game.platform).font(.subheadline)
                            Text("Genres: \(game.genres.joined(separator: ", "))").font(.caption)
                            Text("Status: \(game.status.rawValue.capitalized), Rating: \(game.rating)/10").font(.caption)
                        }
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                    .onTapGesture { detailGame = game }
                    .swipeActions(edge: .trailing) {
                        Button {
                            editingGame = game
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }.tint(.blue)

                        Button(role: .destructive) {
                            viewModel.delete(game: game)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }.onDelete(perform: viewModel.delete)
            }
        }
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("My games")
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
                            editingGame = Game(
                                id: UUID(), title: "", platform: "", coverURL: nil,
                                status: .backlog, rating: 0, notes: "", genres: [],
                                createdAt: ISO8601DateFormatter().string(from: Date())
                            )
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        sortAndFilterMenu
                    }
                }
                .sheet(item: $editingGame) { game in
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
                .navigationDestination(item: $detailGame) { game in
                    if let idx = viewModel.games.firstIndex(where: { $0.id == game.id }) {
                        GameDetailView(
                            game: $viewModel.games[idx],
                            onEdit: { toEdit in editingGame = toEdit }
                        )
                    } else {
                        GameDetailView(
                            game: .constant(game),
                            onEdit: { toEdit in editingGame = toEdit }
                        )
                    }
                }
        }
        .environmentObject(appState)
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search games")
    }
    
    private var sortAndFilterMenu: some View {
        Menu {
            Picker("Sort by", selection: $viewModel.query.sortBy) {
                Text("Created").tag("createdAt")
                Text("Title").tag("title")
                Text("Platform").tag("platform")
                Text("Rating").tag("rating")
            }

            Picker("Order", selection: $viewModel.query.order) {
                Text("Desc").tag("desc")
                Text("Asc").tag("asc")
            }

            Picker("Status", selection: Binding(
                get: { viewModel.query.status ?? .backlog },
                set: { new in
                    viewModel.query.status = (new == .backlog ? nil : new)
                    viewModel.loadGames()
                })) {
                Text("All").tag(GameStatus.backlog)
                ForEach(GameStatus.allCases) { s in
                    if s != .backlog {
                        Text(s.rawValue.capitalized).tag(s)
                    }
                }
            }

        } label: {
            Image(systemName: "arrow.up.arrow.down.square")
        }
    }
}
