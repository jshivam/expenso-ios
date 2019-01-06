//
//  CoreDataManager.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 05/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    private let fileName = "Expenso"
    
    private(set) lazy var applicationDocDir: URL = {
        let urls = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)
        let endIndex = urls.index(before: urls.endIndex)
        return urls[endIndex]
    }()
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: fileName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private(set) lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let sqlFileName = fileName + ".sqlite"
        let url = self.applicationDocDir.appendingPathComponent(sqlFileName)
        
        do{
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        }catch{
            print(error)
            abort()
        }
        
        return coordinator
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.persistentStoreCoordinator = coordinator
        return moc
    }()
    
    lazy var workerManagedContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.parent = self.mainContext
        return moc
    }()
    
    lazy var networkManagedContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.parent = self.workerManagedContext
        return moc
    }()
    
    public func saveContext() {
        self.networkManagedContext.perform {
            self.networkManagedContext.saveIfhasChanges()
            self.workerManagedContext.perform({
                self.workerManagedContext.saveIfhasChanges()
                self.mainContext.perform({
                    self.mainContext.saveIfhasChanges()
                })
            })
        }
    }
    
    func createObject<T: NSManagedObject>(classs: T.Type) -> T {
        let context = networkManagedContext
        let name = className(classs)
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        let object = NSManagedObject(entity: entity, insertInto: context)
        return object as! T
    }
    
    func fetchData<T: NSManagedObject>(from classs: T.Type, predicate: NSPredicate? = nil) -> [T]  {
        let context = workerManagedContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: className(classs))
        request.predicate = predicate
        do {
            let result = try context.fetch(request)
            return result as! [T]
        } catch {
            print("Failed")
        }
        return []
    }
    
    private func className(_ _class: AnyClass) -> String {
        let name = NSStringFromClass(_class).components(separatedBy: ".").last!
        return name
    }
}

extension CoreDataManager
{
}

extension NSManagedObjectContext
{
    func saveIfhasChanges(){
        if self.hasChanges{
            do{
                try self.save()
            }catch{
                fatalError("Error : \(error.localizedDescription)")
            }
        }
    }
}
