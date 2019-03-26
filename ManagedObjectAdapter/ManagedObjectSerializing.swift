//
//  ManagedObjectSerializing.swift
//  ManagedObjectAdapter
//
//  Created by Xin Hong on 16/7/27.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

public protocol ManagedObjectSerializing {
    static func managedObjectEntityName() -> String
    static func managedObjectKeysByPropertyKey() -> [String: String]
    static func valueTransformersByPropertyKey() -> [String: ValueTransformer]
    static func relationshipModelClassesByPropertyKey() -> [String: AnyClass]
    static func propertyKeysForManagedObjectUniquing() -> Set<String>
}

public extension ManagedObjectSerializing {
    static func managedObjectEntityName() -> String {
        return String(describing: self)
    }

    static func managedObjectKeysByPropertyKey() -> [String: String] {
        return [:]
    }

    static func valueTransformersByPropertyKey() -> [String: ValueTransformer] {
        return [:]
    }

    static func relationshipModelClassesByPropertyKey() -> [String: AnyClass] {
        return [:]
    }

    static func propertyKeysForManagedObjectUniquing() -> Set<String> {
        return []
    }
}

public extension ManagedObjectSerializing where Self: NSObject {
    static var propertyKeys: Set<String> {
        if let cachedKeys = objc_getAssociatedObject(self, &AssociatedKeys.cachedPropertyKeys) as? Set<String> {
            return cachedKeys
        }
        let keys = self.init().propertyKeys
        objc_setAssociatedObject(self, &AssociatedKeys.cachedPropertyKeys, keys, .OBJC_ASSOCIATION_COPY)
        return keys
    }

    var propertyKeys: Set<String> {
        var keys = [String]()
        var currentMirror = Mirror(reflecting: self)
        while true {
            keys.append(contentsOf: currentMirror.children.compactMap { $0.label })
            if let superMirror = currentMirror.superclassMirror {
                currentMirror = superMirror
            } else {
                break
            }
        }
        return Set(keys)
    }
}
