//
//  ManagedObjectAdapter.swift
//  ManagedObjectAdapter
//
//  Created by Xin Hong on 16/7/27.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import CoreData

internal func perform(in context: NSManagedObjectContext?, block: @escaping () -> ()) {
    guard let context = context else {
        block()
        return
    }

    #if os(watchOS)
        context.performAndWait(block)
    #else
    if context.concurrencyType == .confinementConcurrencyType {
        block()
    } else {
        context.performAndWait(block)
    }
    #endif
}

public extension ManagedObjectSerializing {
    public static func model(from managedObject: NSManagedObject) -> Self? {
        let propertyKeys = self.propertyKeys
        let managedObjectKeys = generateManagedObjectKeysByPropertyKey()

        for (propertyKey, _) in managedObjectKeys {
            if propertyKeys.contains(propertyKey) {
                continue
            }
            return nil
        }

        let processedModels = [NSManagedObject: Any]()

        return model(from: managedObject, processedModels: processedModels)
    }

    fileprivate static func model(from managedObject: NSManagedObject, processedModels: [NSManagedObject: Any]) -> Self? {
        let propertyKeys = self.propertyKeys
        let managedObjectKeys = generateManagedObjectKeysByPropertyKey()
        let valueTransformers = valueTransformersByPropertyKey()

        if let existingModel = processedModels[managedObject] as? Self {
            return existingModel
        }

        let model = self.init()
        let managedObjectPropertyDescriptions = managedObject.entity.propertiesByName

        var mutableProcessedModels = processedModels
        mutableProcessedModels.updateValue(model, forKey: managedObject)

        for propertyKey in propertyKeys {
            guard let managedObjectKey = managedObjectKeys[propertyKey] else {
                continue
            }
            guard let propertyDescription = managedObjectPropertyDescriptions[managedObjectKey] else {
                continue
            }

            var value: Any?
            perform(in: managedObject.managedObjectContext, block: {
                value = managedObject.value(forKey: managedObjectKey)
            })

            switch propertyDescription {
            case is NSAttributeDescription:
                if let valueTransformer = valueTransformers[propertyKey] {
                    let transformedValue = valueTransformer.reverseTransformedValue(value)
                    model.setValue(transformedValue, forKey: propertyKey)
                } else {
                    model.setValue(value, forKey: propertyKey)
                }
            case is NSRelationshipDescription:
                guard let nestedClass = relationshipModelClassesByPropertyKey()[propertyKey] else {
                    break
                }
                let relationshipDescription = propertyDescription as! NSRelationshipDescription

                if relationshipDescription.isToMany {
                    var models: [Any]?
                    perform(in: managedObject.managedObjectContext, block: {
                        if let relationshipCollection = value {
                            models = (relationshipCollection as AnyObject).objectEnumerator().allObjects.flatMap({ (object) -> Any? in
                                if let nestedManagedObject = object as? NSManagedObject, let nestedClass = nestedClass as? ManagedObjectSerializing.Type {
                                    return nestedClass.model(from: nestedManagedObject, processedModels: mutableProcessedModels)
                                }
                                return nil
                            })
                        }
                    })

                    if !relationshipDescription.isOrdered {
                        let modelsSet: NSSet? = {
                            if let models = models {
                                return NSSet(array: models)
                            }
                            return nil
                        }()
                        model.setValue(modelsSet, forKey: propertyKey)
                    } else {
                        model.setValue(models, forKey: propertyKey)
                    }
                } else {
                    if let nestedManagedObject = value as? NSManagedObject, let nestedClass = nestedClass as? ManagedObjectSerializing.Type {
                        let nestedObject = nestedClass.model(from: nestedManagedObject, processedModels: mutableProcessedModels)
                        model.setValue(nestedObject, forKey: propertyKey)
                    }
                }
            default:
                break
            }
        }

        return model
    }

    public func toManagedObject(in context: NSManagedObjectContext) -> NSManagedObject? {
        let entityName = type(of: self).managedObjectEntityName()
        let valueTransformers = type(of: self).valueTransformersByPropertyKey()
        let managedObjectKeys = type(of: self).generateManagedObjectKeysByPropertyKey()

        var managedObject: NSManagedObject?

        if let uniquingPredicate = generateUniquingPredicate() {
            perform(in: context, block: {
                let fetchRequest = NSFetchRequest<NSManagedObject>()
                fetchRequest.entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
                fetchRequest.predicate = uniquingPredicate
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.fetchLimit = 1

                let results = try? context.fetch(fetchRequest)
                if let object = results?.first {
                    managedObject = object
                }
            })
        }

        if let _ = managedObject {

        } else {
            managedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        }

        let managedObjectPropertyDescriptions = managedObject!.entity.propertiesByName

        for propertyKey in propertyKeys {
            guard let managedObjectKey = managedObjectKeys[propertyKey] else {
                continue
            }
            guard let propertyDescription = managedObjectPropertyDescriptions[managedObjectKey] else {
                continue
            }

            let value = self.value(forKey: propertyKey)

            switch propertyDescription {
            case is NSAttributeDescription:
                if let valueTransformer = valueTransformers[propertyKey] {
                    let transformedValue = valueTransformer.transformedValue(value)
                    managedObject?.setValue(transformedValue, forKey: managedObjectKey)
                } else {
                    managedObject?.setValue(value, forKey: managedObjectKey)
                }
            case is NSRelationshipDescription:
                guard let value = value else {
                    break
                }
                let relationshipDescription = propertyDescription as! NSRelationshipDescription

                if relationshipDescription.isToMany {
                    let relationshipCollection = relationshipDescription.isOrdered ? NSMutableOrderedSet() : NSMutableSet()

                    for nestedValue in (value as AnyObject).objectEnumerator().allObjects {
                        if let nestedObject = nestedValue as? ManagedObjectSerializing, let nestedManagedObject = nestedObject.toManagedObject(in: context) {
                            switch relationshipCollection {
                            case is NSMutableOrderedSet:
                                (relationshipCollection as! NSMutableOrderedSet).add(nestedManagedObject)
                            case is NSMutableSet:
                                (relationshipCollection as! NSMutableSet).add(nestedManagedObject)
                            default:
                                break
                            }
                        }
                    }

                    managedObject?.setValue(relationshipCollection, forKey: managedObjectKey)
                } else {
                    if let nestedObject = value as? ManagedObjectSerializing, let nestedManagedObject = nestedObject.toManagedObject(in: context) {
                        managedObject?.setValue(nestedManagedObject, forKey: managedObjectKey)
                    }
                }
            default:
                break
            }
        }

        if let object = managedObject {
            do {
                try object.validateForInsert()
            } catch {
                perform(in: context, block: {
                    context.delete(object)
                    managedObject = nil
                })
            }
        }

        return managedObject
    }
}

internal extension ManagedObjectSerializing {
    fileprivate static func generateManagedObjectKeysByPropertyKey() -> [String: String] {
        var managedObjectKeys = [String: String]()
        for property in propertyKeys {
            managedObjectKeys.updateValue(property, forKey: property)
        }

        for (propertyKey, managedObjectKey) in managedObjectKeysByPropertyKey() {
            managedObjectKeys.updateValue(managedObjectKey, forKey: propertyKey)
        }

        return managedObjectKeys
    }

    fileprivate func generateUniquingPredicate() -> NSPredicate? {
        let uniquingPropertyKeys = type(of: self).propertyKeysForManagedObjectUniquing()
        let valueTransformers = type(of: self).valueTransformersByPropertyKey()
        let managedObjectKeys = type(of: self).generateManagedObjectKeysByPropertyKey()

        guard uniquingPropertyKeys.count > 0 else {
            return nil
        }

        var subpredicates = [NSPredicate]()
        for uniquingPropertyKey in uniquingPropertyKeys {
            guard let managedObjectKey = managedObjectKeys[uniquingPropertyKey] else {
                continue
            }

            var value = self.value(forKey: uniquingPropertyKey)
            if let transformer = valueTransformers[uniquingPropertyKey] {
                value = transformer.transformedValue(value)
            }

            if let value = value as? NSObject {
                let subpredicate = NSPredicate(format: "%K == %@", managedObjectKey, value)
                subpredicates.append(subpredicate)
            }
        }

        return NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)
    }
}
