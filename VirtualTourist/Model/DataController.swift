//
//  DataController.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 07/07/20.
//  Copyright © 2020 personal. All rights reserved.
//

import CoreData

public final class DataController {
    
    static let shared: DataController = {
        let dc = DataController(modelName: "VirtualTourist")
        dc.load()
        return dc
    }()
    
    private let persistentContainer: NSPersistentContainer
    
    private init(modelName: String) {
        self.persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    var backgroundContext: NSManagedObjectContext!
    
    func configureContexts() {
        backgroundContext = persistentContainer.newBackgroundContext()
        
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    private func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            self.configureContexts()
            completion?()
        }
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

// MARK: Photo Helpers
extension DataController {
    
    func addPhoto(_ photoResponse: PhotoResponse, pin: Pin) {
        let photo = Photo(context: viewContext)
        
        photo.id = photoResponse.id
        photo.imageURL = photoResponse.urlH
        photo.title = photoResponse.title
        photo.pin = pin
        
        do {
            try self.viewContext.save()
            print("Photo added and saved successfully")
        } catch {
            fatalError("Unexpected error adding photo: \(error.localizedDescription)")
        }
    }
    
    func deletePhoto(_ photos: [Photo]) {
        for photo in photos {
            
            do {
                viewContext.delete(photo)
                try viewContext.save()
            } catch {
                fatalError("Unexpected error deleting photo: \(error.localizedDescription)")
            }
        }
    }
    
    func saveImageToAssociatedPhoto(data: Data, photo: Photo) {
        backgroundContext.perform {
            photo.imageData = data
            
            do {
                try self.backgroundContext.save()
                print("Image data saved successfully")
            } catch {
                fatalError("Unexpected error saving associated image to photo: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: Pin Helpers
extension DataController {
    
    func loadPins(completion: @escaping (([Pin]) -> Void)) {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        
        do {
            let result = try DataController.shared.viewContext.fetch(fetchRequest)
            completion(result)
        } catch {
            fatalError("Unexpected error fetching all pins: \(error.localizedDescription)")
        }
    }
    
    func addPin(with latitude: String, and longitude: String, completion: @escaping ((Pin) -> Void)) {
        let pin = Pin(context: viewContext)
        
        pin.latitude = latitude
        pin.longitude = longitude
        
        do {
            try self.viewContext.save()
            completion(pin)
        } catch {
            fatalError("Unexpected error adding pin: \(error.localizedDescription)")
        }
    }
    
    func getPin(for latitude: String, and longitude: String, completion: @escaping ((Pin?) -> Void)) {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let predicate = NSPredicate(format: "latitude == %@ && longitude == %@", latitude, longitude)
        fetchRequest.predicate = predicate
           
        do {
            let pin = try viewContext.fetch(fetchRequest).first
            completion(pin)
        } catch {
            fatalError("Unexpected error fetching pin: \(error.localizedDescription)")
        }
    }
    
    func updatePin(_ pin: Pin, with latitude: String, and longitude: String, completion: @escaping ((Pin) -> Void)) {
        backgroundContext.perform {
            pin.latitude = latitude
            pin.longitude = longitude
            pin.photo = nil
            
            do {
                try self.backgroundContext.save()
                completion(pin)
            } catch {
                fatalError("Unexpected error updating pin location: \(error.localizedDescription)")
            }
        }
    }
}
