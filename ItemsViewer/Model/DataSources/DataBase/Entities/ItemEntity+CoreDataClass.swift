//
//  ItemEntity+CoreDataClass.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 09.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ItemEntity)
public class ItemEntity: NSManagedObject {

    func object() -> Item? {
        guard let name = self.name else { return nil }
        guard let description = self.itemDescription else { return nil }
        guard let image = self.image else { return nil }
        guard let dose = self.info else { return nil }
        
        let item = Item(id: Int(self.id),
                        name: name,
                        description: description,
                        image: image,
                        dose: dose)
        
        return item
    }
    
    class func entitiesFrom(items: [Item], context: NSManagedObjectContext) -> [ItemEntity] {
        var entites: [ItemEntity] = []
        for item in items {
            let entity = ItemEntity.entityFrom(item: item, context: context)
            entites.append(entity)
        }
        return entites
    }
    
    class func entityFrom(item: Item, context: NSManagedObjectContext) -> ItemEntity {

        let predicate = NSPredicate(format: "id == %d", item.id)
        let entity: ItemEntity = DBDataSource.getEntity(name: "ItemEntity", predicate: predicate, context: context)
        
        entity.id = Int16(item.id)
        
        entity.name = item.name
        entity.itemDescription = item.description
        
        entity.image = item.image
        
        entity.info = item.dose
        
        return entity
    }
}
