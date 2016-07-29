//
//  ManagedObjectAdapter.swift
//  ManagedObjectAdapter
//
//  Created by Xin Hong on 16/7/27.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import CoreData

public extension ManagedObjectSerializing where Self: NSObject {
    public static func modelFromManagedObject(managedObject: NSManagedObject) -> ManagedObjectSerializing? {
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

        return nil
    }

    public func toManagedObject(context: NSManagedObjectContext) -> NSManagedObject? {
        let entityName = self.dynamicType.managedObjectEntityName()

        var managedObject: NSManagedObject?
        managedObject = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context)

        let _ = self.dynamicType.valueTransformers()
        let managedObjectProperties = managedObject!.entity.propertiesByName
        for key in propertyKeys {
            guard let property = managedObjectProperties[key] else {
                continue
            }
            let value = valueForKey(key)
            if key == "name" || key == "id" || key == "teamsCount" || key == "logo" || key == "createdAt" {
                managedObject?.setValue(value, forKey: key)
            }
        }

        return managedObject
    }

    internal static func valueTransformers() -> [String: NSValueTransformer] {
        for key in propertyKeys {
            let selector = selectorWithKeyPattern(key, suffix: "EntityAttributeTransformer")
            print(selector)
        }
        return [:]
    }
}

internal func selectorWithKeyPattern(key: String, suffix: String) -> Selector? {
    var keyLength = key.maximumLengthOfBytesUsingEncoding(NSUTF8StringEncoding)
    let suffixLength = strlen(suffix)
    var selector = String()
    var buffer = [UInt8](selector.utf8)
    let range = key.startIndex..<key.startIndex.advancedBy(key.characters.count)
    let success = key.getBytes(&buffer,
                               maxLength: keyLength,
                               usedLength: &keyLength,
                               encoding: NSUTF8StringEncoding,
                               options: [],
                               range: range,
                               remainingRange: nil)
    guard success else {
        return nil
    }
    return sel_registerName(selector)
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
