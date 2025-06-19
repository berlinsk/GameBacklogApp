//
//  Game.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 08.06.2025.
//

import Foundation

struct Game: Codable, Identifiable, Hashable {
    let id: UUID
    var title: String
    var platform: String
    var coverURL: String?
    var status: GameStatus
    var rating: Int
    var notes: String
    var genres: [String]
    var createdAt: String
    
    func matches(_ query: String) -> Bool {
        let q = query.lowercased()
        let t = title.lowercased()
        if t.contains(q) { return true }
        return t.similarity(to: q) >= 0.75
    }
}
