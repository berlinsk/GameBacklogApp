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
    @State private var isSortMenuPresented = false

    @ViewBuilder
    var content: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()
            List {
                ForEach(viewModel.games) { game in
                    HStack(alignment: .top, spacing: 12) {
                        if let urlString = game.coverURL,
                           let url = URL(string: urlString) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView().frame(width: 60, height: 60)
                                case .success(let image):
                                    image.resizable()
                                         .scaledToFill()
                                         .frame(width: 60, height: 60)
                                         .clipped()
                                         .cornerRadius(8)
                                default:
                                    Color.gray.frame(width: 60, height: 60)
                                             .cornerRadius(8)
                                }
                            }
                        } else {
                            Color.gray.frame(width: 60, height: 60)
                                      .cornerRadius(8)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(game.title)
                                .font(Theme.Fonts.title(size: 18))
                                .foregroundColor(Theme.Colors.neonText)

                            Text(game.platform)
                                .font(Theme.Fonts.subtitle(size: 14))
                                .foregroundColor(Theme.Colors.softText)

                            Text("Genres: \(game.genres.joined(separator: ", "))")
                                .font(Theme.Fonts.body(size: 14))
                                .foregroundColor(Theme.Colors.softText)

                            Text("Status: \(game.status.rawValue.capitalized), Rating: \(game.rating)/10")
                                .font(Theme.Fonts.caption(size: 13))
                                .foregroundColor(Theme.Colors.softText)
                        }
                    }
                    .padding(.vertical, 4)
                    .neonCard()
                    .contentShape(Rectangle())
                    .onTapGesture { detailGame = game }
                    .swipeActions(edge: .trailing) {
                        Button { editingGame = game } label: {
                            Label("Edit", systemImage: "pencil")
                        }.tint(.blue)

                        Button(role: .destructive) {
                            viewModel.delete(game: game)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .onAppear { viewModel.loadMore(current: game) }   // pagination
                }
                .onDelete(perform: viewModel.delete)
            }
            .listStyle(.plain)
            .background(Theme.Colors.background)
            .animation(nil, value: viewModel.games)   // pagination without animation

            // spinner
            if viewModel.isLoading {
                ProgressView("Loading…")
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(12)
            }

            if let error = viewModel.errorMessage {
                Text("Ooops: \(error)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack {
                    Button {
                        editingGame = Game(
                            id: UUID(), title: "", platform: "", coverURL: nil,
                            status: .backlog, rating: 0, notes: "", genres: [],
                            createdAt: ISO8601DateFormatter().string(from: Date())
                        )
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(Theme.Colors.accent)
                    }

                    Spacer()

                    Button("Logout") {
                        appState.logout()
                    }
                    .font(Theme.Fonts.body())
                    .foregroundColor(Theme.Colors.accent)

                    Button(action: {
                        isSortMenuPresented = true
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title2)
                            .foregroundColor(Theme.Colors.accent)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: Theme.Metrics.cardCornerRadius)
                                    .stroke(Theme.Colors.accent, lineWidth: 1.5)
                            )
                    }
                    .sheet(isPresented: $isSortMenuPresented) {
                        SortAndFilterMenu(isPresented: $isSortMenuPresented, viewModel: viewModel)
                    }
                }
                .padding(.horizontal)

                Text("My games (\(viewModel.games.count)/\(viewModel.total))")
                    .retroTitle()

                TextField("Search games", text: $viewModel.searchText)
                    .font(Theme.Fonts.body())
                    .padding(8)
                    .background(Theme.Colors.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Theme.Colors.accent.opacity(0.3), lineWidth: 1)
                    )
                    .cornerRadius(8)
                    .padding(.horizontal)

                content
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .onAppear { viewModel.loadGames() }
            .refreshable { viewModel.loadGames() }
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
    }
}
