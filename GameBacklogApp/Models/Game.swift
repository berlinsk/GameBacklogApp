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

        if t.contains(q) {
            return true
        }

        let windowSize = q.count
        guard windowSize <= t.count else { return false }

        var bestScore = 0.0
        for i in 0...(t.count - windowSize) {
            let start = t.index(t.startIndex, offsetBy: i)
            let end = t.index(start, offsetBy: windowSize)
            let substr = String(t[start..<end])
            let score = substr.similarity(to: q)
            bestScore = max(bestScore, score)
        }

        return bestScore >= 0.75
    }
}
