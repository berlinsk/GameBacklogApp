//
//  GameListViewModel.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 08.06.2025.
//

import Foundation
import Combine

class GameListViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var query = APIService.GameQuery()
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    
    private var cancellable: AnyCancellable?

    init() {
        cancellable = $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.query.search = text.isEmpty ? nil : text
                self?.loadGames()
            }
    }
    
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

        APIService.shared.fetchGames(query: query) { [weak self] result in
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
            delete(game: game)
        }
    }

    func delete(game: Game) {
        APIService.shared.deleteGame(game.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.games.removeAll { $0.id == game.id }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
