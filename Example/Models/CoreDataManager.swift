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
    func managedObject(ID: String) -> NSManagedObject? {
        guard let URL = NSURL(string: ID), managedObjectID = CoreDataManager.persistentStoreCoordinator?.managedObjectIDForURIRepresentation(URL) else {
            return nil
        }
        return try? existingObjectWithID(managedObjectID)
    }
}

struct CoreDataManager {
    static let context: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()

    static let coreDataStorePath: String? = {
        guard let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first else {
            return nil
        }

        let coreDataStorePath = (documentsPath as NSString).stringByAppendingPathComponent("com.teambition")
        if !NSFileManager.defaultManager().fileExistsAtPath(coreDataStorePath) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(coreDataStorePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return nil
            }
        }

        let path = ((coreDataStorePath as NSString).stringByAppendingPathComponent("ManagedObjectAdapterExample") as NSString).stringByAppendingPathExtension("sqlite")
        return path
    }()

    static let persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        let bundle = NSBundle(forClass: ManagedObject.self)
        guard let managedObjectModel = NSManagedObjectModel.mergedModelFromBundles([bundle]) else {
            return nil
        }
        guard let coreDataStorePath = coreDataStorePath else {
            return nil
        }
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let coreDataStoreURL = NSURL(fileURLWithPath: coreDataStorePath)
        do {
            try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: coreDataStoreURL, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
        } catch {
            
        }
        return persistentStoreCoordinator
    }()
}
