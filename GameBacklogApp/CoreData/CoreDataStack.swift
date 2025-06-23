//
//  CoreDataStack.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 23.06.2025.
//

import Foundation
import CoreData

final class StringArrayTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] { [NSArray.self, NSString.self] }
}

final class CoreDataStack {
    static let shared = CoreDataStack()
    let container: NSPersistentContainer

    private init() {
        let name = NSValueTransformerName("StringArrayTransformer")
        ValueTransformer.setValueTransformer(StringArrayTransformer(), forName: name)
        
        container = NSPersistentContainer(name: "GameEntity")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("CoreData load error: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    @MainActor
    static func save() {
        let ctx = shared.container.viewContext
        if ctx.hasChanges {
            try? ctx.save()
        }
    }
}
