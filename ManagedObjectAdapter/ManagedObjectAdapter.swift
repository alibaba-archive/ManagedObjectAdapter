//
//  ManagedObjectAdapter.swift
//  ManagedObjectAdapter
//
//  Created by Xin Hong on 16/7/27.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import CoreData

public extension ManagedObjectSerializing where Self: AnyObject {
    public static func modelFromManagedObject(managedObject: NSManagedObject) {
        let propertyKeys = self.propertyKeys
        for (key, _) in managedObjectKeysByPropertyKey() {
            if propertyKeys.contains(key) {
                continue
            }
        }

        let context = managedObject.managedObjectContext
        let managedObjectProperties = managedObject.entity.propertiesByName

        for propertyKey in propertyKeys {
            guard let managedObjectKey = managedObjectKeysByPropertyKey()[propertyKey] else {
                continue
            }
            let value = managedObject.valueForKey(managedObjectKey)
        }
    }

    public func toManagedObject() {
        
    }

    internal func performInContext(context: NSManagedObjectContext, block: () -> Void) {
        if context.concurrencyType == .ConfinementConcurrencyType {
            block()
        } else {
            context.performBlockAndWait({
                block()
            })
        }
    }
}


//public struct ManagedObjectAdapter {
//    public private(set) var modelClass: AnyClass
//    public private(set) var managedObjectKeysByPropertyKey: [String: String]
//
//    public init(modelClass: AnyClass) {
//        self.modelClass = modelClass
//    }
//}
//
//public extension ManagedObjectAdapter {
//    public static func modelOfClass(modelClass: AnyClass, fromManagedObject managedObject: NSManagedObject) {
//
//    }
//
//    public func modelFromManagedObject(managedObject: NSManagedObject) {
//        
//    }
//
//    public func managedObjectFromModel(model: ManagedObjectSerializing) {
//        
//    }
//}
