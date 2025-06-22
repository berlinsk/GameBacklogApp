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
    @Published var total: Int = 0 // number of games
    
    private var page = 10 // page size
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

    func loadGames(reset: Bool = true) {
        if reset {
            query.offset = 0
            games.removeAll()
            isLoading = true
        }
        query.limit = page

        APIService.shared.fetchGames(query: query) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let response):
                    if reset {
                        self.games = response.games
                    } else {
                        self.games.append(contentsOf: response.games)
                    }
                    self.total = response.total

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }

                if reset {
                    self.isLoading = false
                }
            }
        }
    }
    
    func loadMore(current game: Game) {
        guard !isLoading, games.last == game, games.count < total else { return }
        query.offset += page
        loadGames(reset: false)
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
