//
//  GameStatus.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 08.06.2025.
//

import Foundation

enum GameStatus: String, Codable {
    case backlog
    case playing
    case completed
    case abandoned
}
