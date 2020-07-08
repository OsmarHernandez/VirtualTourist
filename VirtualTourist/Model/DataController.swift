//
//  DataController.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 07/07/20.
//  Copyright © 2020 personal. All rights reserved.
//

import CoreData

public final class DataController {
    
    let persistentContainer: NSPersistentContainer
    
    init(modelName: String) {
        self.persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            completion?()
        }
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
