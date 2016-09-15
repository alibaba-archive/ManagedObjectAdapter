//
//  CoreDataManager.swift
//  Example
//
//  Created by Xin Hong on 16/7/29.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func managedObject(_ ID: String) -> NSManagedObject? {
        guard let url = URL(string: ID), let managedObjectID = CoreDataManager.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url) else {
            return nil
        }
        return try? existingObject(with: managedObjectID)
    }
}

struct CoreDataManager {
    static let context: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()

    static let coreDataStorePath: String? = {
        guard let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }

        let coreDataStorePath = (documentsPath as NSString).appendingPathComponent("com.teambition")
        if !FileManager.default.fileExists(atPath: coreDataStorePath) {
            do {
                try FileManager.default.createDirectory(atPath: coreDataStorePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return nil
            }
        }

        let path = ((coreDataStorePath as NSString).appendingPathComponent("ManagedObjectAdapterExample") as NSString).appendingPathExtension("sqlite")
        return path
    }()

    static let persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        let bundle = Bundle(for: ManagedObject.self)
        guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: [bundle]) else {
            return nil
        }
        guard let coreDataStorePath = coreDataStorePath else {
            return nil
        }
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let coreDataStoreURL = URL(fileURLWithPath: coreDataStorePath)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: coreDataStoreURL, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
        } catch {
            
        }
        return persistentStoreCoordinator
    }()
}
