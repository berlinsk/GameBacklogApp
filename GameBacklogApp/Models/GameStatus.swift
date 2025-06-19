//
//  GameStatus.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 08.06.2025.
//

import Foundation

enum GameStatus: String, Codable, CaseIterable, Identifiable {
    case backlog
    case playing
    case completed
    case abandoned
    
    var id: String { self.rawValue }
}
