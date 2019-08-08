//
//  DataManager.swift
//  ContractionTimer
//
//  Created by Oscar Echeverri on 2019-07-09.
//  Copyright © 2019 FoxNet. All rights reserved.
//
import CoreData
import os.log
class DataManager {
    
    static var shared = DataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ContractionTimer")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                os_log(.error, log: OSLog.data, "Unresolved error %{public}@, %@", error.localizedDescription, error.userInfo)
            }
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
}
