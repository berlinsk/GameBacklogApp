//
//  GameListViewModel.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 08.06.2025.
//

import Foundation

class GameListViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func add(game: Game) {
        isLoading = true
        APIService.shared.createGame(game) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let newGame):
                    self?.games.append(newGame)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func loadGames() {
        isLoading = true
        errorMessage = nil

        APIService.shared.fetchGames { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let games):
                    self?.games = games
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func save(game: Game) {
        isLoading = true
        APIService.shared.updateGame(game) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let updated):
                    if let index = self?.games.firstIndex(where: { $0.id == updated.id }) {
                        self?.games[index] = updated
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let game = games[index]
            APIService.shared.deleteGame(game.id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.games.remove(at: index)
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}
