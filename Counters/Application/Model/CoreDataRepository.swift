//
//  CoreDataRepository.swift
//  Counters
//
//  Created by David A Cespedes R on 5/5/21.
//

import Foundation
import CoreData

class CoreDataRepository: Repository {
    
    typealias Entity = CounterModelProtocol
    private let entityName = "CounterManagedObject"

    // MARK: - Core Data Stack Configuration

    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CounterDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Core Data Methods

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func getEntities(entityName: String) -> [CounterManagedObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            if let entities = try managedObjectContext.fetch(request) as? [CounterManagedObject] {
                return entities
            }
        } catch {
            return nil
        }
        return nil
    }

    func cleanDB() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try managedObjectContext.execute(request)
            saveContext()
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }

    // MARK: - Repository Implementation

    func getCounters(completionHandler: @escaping (Result<[CounterModelProtocol]?, Error>) -> Void) {
        guard let fetchedItems = getEntities(entityName: entityName) else {
            return completionHandler(.success([]))
        }

        let fetchedCounters = fetchedItems.compactMap({ CounterModel(entity: $0 as! CounterManagedObject) })
        completionHandler(.success(fetchedCounters))
    }

    func createCounter(_ counter: CounterModelProtocol,
                       completionHandler: @escaping (Result<[CounterModelProtocol]?, Error>) -> Void) {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName,
                                                      in: managedObjectContext) else {
            return completionHandler(.success(nil))
        }

        let managedObject = NSManagedObject(entity: entity,
                                            insertInto: managedObjectContext)
        if let counterManagedObject = managedObject as? CounterManagedObject {
            counterManagedObject.count = Double(counter.count)
            counterManagedObject.title = counter.title
            counterManagedObject.id = counter.id
        }
    }

    func increaseCounter(id: String, completionHandler: @escaping (Result<[CounterModelProtocol]?, Error>) -> Void) {
        // May be needed if we prefer an offline first aproach
    }

    func decreaseCounter(id: String, completionHandler: @escaping (Result<[CounterModelProtocol]?, Error>) -> Void) {
        // May be needed if we prefer an offline first aproach
    }

    func deleteCounter(id: String, completionHandler: @escaping (Result<[CounterModelProtocol]?, Error>) -> Void) {
        // May be needed if we prefer an offline first aproach
    }

}

extension CounterModel {
    init?(entity: CounterManagedObject) {
        guard let id = entity.id, let title = entity.title else {
            return nil
        }
        self.id = id
        self.title = title
        self.count = Int(entity.count)
    }
}
