//
//  DataController.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 07/07/20.
//  Copyright © 2020 personal. All rights reserved.
//

import CoreData

public final class DataController {
    
    // not all objects in Core Data are Thread Safe
    private let concurrentQueue = DispatchQueue(
        label: "concurrentQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    static let shared: DataController = {
        let dc = DataController(modelName: "VirtualTourist")
        dc.load()
        return dc
    }()
    
    private let persistentContainer: NSPersistentContainer
    
    private init(modelName: String) {
        self.persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    private func load(completion: (() -> Void)? = nil) {
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

extension DataController {
    
    func loadPins(completion: @escaping (([Pin]) -> Void)) {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        
        concurrentQueue.sync {
            do {
                let result = try DataController.shared.viewContext.fetch(fetchRequest)
                completion(result)
            } catch {
                completion([])
            }
        }
    }
    
    func addPin(with latitude: String, and longitude: String, completion: @escaping ((Pin) -> Void)) {
        let pin = Pin(context: viewContext)
        
        concurrentQueue.async(flags: .barrier) {
            pin.latitude = latitude
            pin.longitude = longitude
            try! self.viewContext.save()
            
            completion(pin)
        }
    }
    
    func getPin(for latitude: String, and longitude: String, completion: @escaping ((Pin?) -> Void)) {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let predicate = NSPredicate(format: "latitude == %@ && longitude == %@", latitude, longitude)
        fetchRequest.predicate = predicate
           
        concurrentQueue.sync {
            do {
                let pin = try viewContext.fetch(fetchRequest).first
                completion(pin)
            } catch {
                completion(nil)
            }
        }
    }
    
    func updatePin(_ pin: Pin, with latitude: String, and longitude: String, completion: @escaping ((Pin?) -> Void)) {
        concurrentQueue.async(flags: .barrier) {
            pin.latitude = latitude
            pin.longitude = longitude
            
            do {
                try self.viewContext.save()
                completion(pin)
            } catch {
                completion(nil)
            }
        }
    }
}
