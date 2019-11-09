//
//  DBDataSource.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 09.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import Foundation
import CoreData


typealias DBDataSourceSaveCompletion = (_ isSaved: Bool) -> Void
typealias DBDataSourceLoadItemsCompletion = (_ items: [Item]) -> Void


protocol DBDataSourceProtocol {
    func save(items: [Item], completion: @escaping DBDataSourceSaveCompletion)
    func loadItems(completion: @escaping DBDataSourceLoadItemsCompletion)
}


final class DBDataSource {
    private init() {}
    
    static let shared: DBDataSourceProtocol = DBDataSource()
    
    private lazy var coreDataStack: CoreDataStackProtocol = {
       return CoreDataStack()
    }()
}


// MARK: -

extension DBDataSource: DBDataSourceProtocol {
    
    func loadItems(completion: @escaping DBDataSourceLoadItemsCompletion) {
        self.coreDataStack.getPersistentContainer().performBackgroundTask { (context: NSManagedObjectContext) in
            
            let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
            
            var entites: [ItemEntity] = []
            do {
                entites = try context.fetch(request)
            } catch {
                #if DEBUG
                fatalError("Exception \(#file) \(#function) \(#line)")
                #else
                debugPrint("Exception \(#file) \(#function) \(#line)")
                #endif
            }
            
            var items: [Item] = []
            for entity in entites {
                if let item = entity.object() {
                    items.append(item)
                }
            }
            
            completion(items)
        }
    }
    
    func save(items: [Item], completion: @escaping DBDataSourceSaveCompletion) {
        if items.isEmpty {
            completion(true)
            return
        }
        
        self.coreDataStack.getPersistentContainer().performBackgroundTask { (context: NSManagedObjectContext) in
            _ = ItemEntity.entitiesFrom(items: items, context: context)
            let isSaved = self.save(context: context)
            
            completion(isSaved)
        }
    }
}

extension DBDataSource {
    
    static func getEntity<T: NSFetchRequestResult>(name: String, predicate: NSPredicate, context: NSManagedObjectContext) -> T {
        let request: NSFetchRequest = NSFetchRequest<T>(entityName: name)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let result = try context.fetch(request)
            if let first = result.first {
                return first
            }
        } catch {
            #if DEBUG
            fatalError("Exception \(#file) \(#function) \(#line)")
            #else
            debugPrint("Exception \(#file) \(#function) \(#line)")
            #endif
        }

        return NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! T
    }
    
    func save(context: NSManagedObjectContext) -> Bool {
        
        var isSaved = false
        do {
            try context.save()
            isSaved = true
        } catch {
            #if DEBUG
            fatalError("Exception \(#file) \(#function) \(#line) \(error)")
            #else
            debugPrint("Exception \(#file) \(#function) \(#line) \(error)")
            #endif
        }
        
        return isSaved
    }
}


// MARK: - CoreDataStack

protocol CoreDataStackProtocol {
    func getPersistentContainer() -> NSPersistentContainer
}


private final class CoreDataStack: CoreDataStackProtocol {
    
    // MARK: - CoreDataStackProtocol
    
    func getPersistentContainer() -> NSPersistentContainer {
        return self.persistentContainer
    }

    
    // MARK: -
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.dbName)
        
        if let fileURL = self.dbFileURL() {
            let description = NSPersistentStoreDescription(url: fileURL)
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { (description, error) in
            #if DEBUG
            debugPrint("loadPersistentStores: \(description) \(String(describing: error))")
            #endif
        }
        return container
    }()

    private let dbName = "ItemsViewer"
    
    private func dbFileURL() -> URL? {
    
        guard let documentsDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            #if DEBUG
            fatalError("Exception \(#file) \(#function) \(#line) no documents directory")
            #else
            debugPrint("Exception \(#file) \(#function) \(#line) no documents directory")
            return nil
            #endif
        }
        
        let fileURL = documentsDirURL.appendingPathComponent("\(self.dbName).sqlite")

        if false == FileManager.default.fileExists(atPath: fileURL.path) {
            self.copyBundleFiles(documentsDirURL: documentsDirURL)
        }
        
        #if DEBUG
        debugPrint("dbFileURL \(fileURL)")
        #endif
        
        return fileURL
    }
    
    private func copyBundleFiles(documentsDirURL: URL) {
        guard let bundleSqlite = Bundle.main.url(forResource: self.dbName, withExtension: "sqlite") else  {
            #if DEBUG
            fatalError("Exception \(#file) \(#function) \(#line) no bundleSqlite file")
            #else
            debugPrint("Exception \(#file) \(#function) \(#line) no bundleSqlite file")
            return
            #endif
        }
        
        do {
            let fileURL = documentsDirURL.appendingPathComponent("\(self.dbName).sqlite")
            try FileManager.default.copyItem(at: bundleSqlite, to: fileURL)
        } catch {
            #if DEBUG
            fatalError("Exception \(#file) \(#function) \(#line) \(error)")
            #else
            debugPrint("Exception \(#file) \(#function) \(#line) \(error)")
            #endif
        }
    }
}
