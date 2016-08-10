//
//  ManagedObjectAdapter.swift
//  ManagedObjectAdapter
//
//  Created by Xin Hong on 16/7/27.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import CoreData

public extension ManagedObjectSerializing {
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
        let valueTransformers = self.dynamicType.valueTransformersByPropertyKey()
        let managedObjectKeys = self.dynamicType.generateManagedObjectKeysByPropertyKey()

        var managedObject: NSManagedObject?
        managedObject = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context)

        let managedObjectPropertyDescriptions = managedObject!.entity.propertiesByName

        for propertyKey in propertyKeys {
            guard let managedObjectKey = managedObjectKeys[propertyKey] else {
                continue
            }
            guard let propertyDescription = managedObjectPropertyDescriptions[managedObjectKey] else {
                continue
            }

            let value = valueForKey(propertyKey)

            switch propertyDescription {
            case is NSAttributeDescription:
                if let valueTransformer = valueTransformers[propertyKey] {
                    let transformedValue = valueTransformer.transformedValue(value)
                    managedObject?.setValue(transformedValue, forKey: managedObjectKey)
                } else {
                    managedObject?.setValue(value, forKey: managedObjectKey)
                }
            case is NSRelationshipDescription:
                let relationshipDescription = propertyDescription as! NSRelationshipDescription

                if relationshipDescription.toMany {
                    if let valueEnumerator = value?.objectEnumerator() {
                        let relationshipCollection = relationshipDescription.ordered ? NSMutableOrderedSet() : NSMutableSet()

                        for nestedValue in valueEnumerator.allObjects {
                            if let nestedObject = nestedValue as? ManagedObjectSerializing, nestedManagedObject = nestedObject.toManagedObject(context) {
                                switch relationshipCollection {
                                case is NSMutableOrderedSet:
                                    (relationshipCollection as! NSMutableOrderedSet).addObject(nestedManagedObject)
                                case is NSMutableSet:
                                    (relationshipCollection as! NSMutableSet).addObject(nestedManagedObject)
                                default:
                                    break
                                }
                            }
                        }

                        managedObject?.setValue(relationshipCollection, forKey: managedObjectKey)
                    }
                } else {
                    if let nestedObject = value as? ManagedObjectSerializing, nestedManagedObject = nestedObject.toManagedObject(context) {
                        managedObject?.setValue(nestedManagedObject, forKey: managedObjectKey)
                    }
                }
            default:
                break
            }
        }

        return managedObject
    }
}

internal extension ManagedObjectSerializing {
    internal static func generateManagedObjectKeysByPropertyKey() -> [String: String] {
        var managedObjectKeys = [String: String]()
        for property in propertyKeys {
            managedObjectKeys.updateValue(property, forKey: property)
        }

        for (managedObjectKey, propertyKey) in managedObjectKeysByPropertyKey() {
            managedObjectKeys.updateValue(propertyKey, forKey: managedObjectKey)
        }

        return managedObjectKeys
    }
}

//internal func selectorWithKeyPattern(key: String, suffix: String) -> Selector? {
//    var keyLength = key.maximumLengthOfBytesUsingEncoding(NSUTF8StringEncoding)
//    let suffixLength = strlen(suffix)
//    var selector = String()
//    var buffer = [UInt8](selector.utf8)
//    let range = key.startIndex..<key.startIndex.advancedBy(key.characters.count)
//    let success = key.getBytes(&buffer,
//                               maxLength: keyLength,
//                               usedLength: &keyLength,
//                               encoding: NSUTF8StringEncoding,
//                               options: [],
//                               range: range,
//                               remainingRange: nil)
//    guard success else {
//        return nil
//    }
//    return sel_registerName(selector)
//}

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
