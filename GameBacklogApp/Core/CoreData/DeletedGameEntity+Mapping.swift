//
//  DeletedGameEntity+Mapping.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 24.06.2025.
//

import Foundation
import CoreData

extension DeletedGameEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeletedGameEntity> {
        NSFetchRequest<DeletedGameEntity>(entityName: "DeletedGameEntity")
    }

    @NSManaged public var id: UUID
}
