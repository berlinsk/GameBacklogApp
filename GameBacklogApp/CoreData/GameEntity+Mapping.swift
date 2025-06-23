//
//  GameEntity+Mapping.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 23.06.2025.
//

import Foundation
import CoreData

@objc(GameEntity)
public class GameEntity: NSManagedObject {}

extension GameEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameEntity> {
        NSFetchRequest<GameEntity>(entityName: "GameEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var platform: String
    @NSManaged public var coverURL: String?
    @NSManaged public var statusRaw: String
    @NSManaged public var rating: Int16
    @NSManaged public var notes: String
    @NSManaged public var genres: [String]
    @NSManaged public var createdAt: String
    @NSManaged public var isSynced: Bool
}

extension GameEntity {
    func update(from model: Game) {
        id         = model.id
        title      = model.title
        platform   = model.platform
        coverURL   = model.coverURL
        statusRaw  = model.status.rawValue
        rating     = Int16(model.rating)
        notes      = model.notes
        genres     = model.genres
        createdAt  = model.createdAt
    }

    func toModel() -> Game {
        .init(id: id,
              title: title,
              platform: platform,
              coverURL: coverURL,
              status: GameStatus(rawValue: statusRaw) ?? .backlog,
              rating: Int(rating),
              notes: notes,
              genres: genres,
              createdAt: createdAt)
    }
}
