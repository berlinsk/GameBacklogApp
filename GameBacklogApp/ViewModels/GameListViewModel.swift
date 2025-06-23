//
//  GameListViewModel.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 08.06.2025.
//

import Foundation
import SwiftUI
import Combine
import CoreData
import Network

class GameListViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var query = APIService.GameQuery()
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var total: Int = 0 // number of games
    @Published private var isOnline = true
    
    private var page = 10 // page size
    private var cancellable: AnyCancellable?
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetMonitor")

    init() {
        cancellable = $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.query.search = text.isEmpty ? nil : text
                self?.loadGames()
            }
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isOnline = path.status == .satisfied
                if path.status == .satisfied {
                    self?.syncUnsyncedGames()
                }
            }
        }
        monitor.start(queue: monitorQueue)
    }
    
    func add(game: Game) {
        isLoading = true
        APIService.shared.createGame(game) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let newGame):
                    self?.games.append(newGame)
                    self?.saveToCoreData(games: [newGame], reset: false)
                case .failure(let error):
                    self?.games.append(game)
                    self?.saveToCoreData(games: [game], reset: false, markSynced: false)
                    self?.errorMessage = "Offline save"
                }
            }
        }
    }

    func loadGames(reset: Bool = true) {
        if !isOnline { // downloading cache
            loadFromCoreData()
            return
        }
        if reset {
            query.offset = 0
            isLoading = true
            withAnimation(.none) {
                games.removeAll()
            }
        }
        query.limit = page

        APIService.shared.fetchGames(query: query) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let response):
                    if reset {
                        self.games = response.games
                        self.saveToCoreData(games: response.games, reset: true)
                    } else {
                        self.games.append(contentsOf: response.games)
                        self.saveToCoreData(games: response.games, reset: false)
                    }
                    self.total = response.total

                case .failure:
                    self.loadFromCoreData() // fallback to the cache
                    self.errorMessage = "Offline mode"
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
                        self?.saveToCoreData(games: [updated], reset: false)
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    @MainActor
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let game = games[index]
            delete(game: game)
        }
    }

    @MainActor
    func delete(game: Game) {
        if isOnline {
            APIService.shared.deleteGame(game.id) { [weak self] result in
                DispatchQueue.main.async {
                    self?.removeLocally(game)
                    if case .failure(let err) = result {
                        self?.errorMessage = err.localizedDescription
                    }
                }
            }
        } else {
            removeLocally(game)
        }
    }
    
    @MainActor
    private func saveToCoreData(games: [Game], reset: Bool, markSynced: Bool = true) {
        let context = CoreDataStack.shared.container.viewContext

        if reset {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = GameEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try? context.execute(deleteRequest)
        }

        for game in games {
            let entity = GameEntity(context: context)
            entity.update(from: game)
            entity.isSynced = markSynced
        }

        CoreDataStack.save()
    }
    
    private func loadFromCoreData() {
        let ctx = CoreDataStack.shared.container.viewContext
        let request: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        if let entities = try? ctx.fetch(request) {
            self.games = entities.map { $0.toModel() }
            self.total = games.count
        }
    }

    @MainActor
    private func removeLocally(_ game: Game) {
        games.removeAll { $0.id == game.id }

        let ctx = CoreDataStack.shared.container.viewContext
        let req: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", game.id as CVarArg)
        if let entity = try? ctx.fetch(req).first {
            ctx.delete(entity)
            CoreDataStack.save()
        }
    }
    
    private func syncUnsyncedGames() {
        let context = CoreDataStack.shared.container.viewContext
        let request: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isSynced == NO")

        if let unsynced = try? context.fetch(request) {
            for entity in unsynced {
                let game = entity.toModel()
                APIService.shared.createGame(game) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let syncedGame):
                            entity.update(from: syncedGame)
                            entity.isSynced = true
                            CoreDataStack.save()
                            if let idx = self.games.firstIndex(where: { $0.id == syncedGame.id }) {
                                self.games[idx] = syncedGame
                            } else {
                                self.games.append(syncedGame)
                            }
                        case .failure:
                            break
                        }
                    }
                }
            }
        }
    }
}
