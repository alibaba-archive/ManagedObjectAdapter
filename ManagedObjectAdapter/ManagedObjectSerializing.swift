//
//  ManagedObjectSerializing.swift
//  ManagedObjectAdapter
//
//  Created by Xin Hong on 16/7/27.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

public protocol ManagedObjectSerializing: AnyObject {
    init()
    func valueForKey(key: String) -> AnyObject?

    static func managedObjectEntityName() -> String
    static func managedObjectKeysByPropertyKey() -> [String: String]
    static func valueTransformersByPropertyKey() -> [String: NSValueTransformer]
    static func propertyKeysForManagedObjectUniquing() -> Set<String>
}

public extension ManagedObjectSerializing {
    static func managedObjectEntityName() -> String {
        return String(self)
    }

    static func managedObjectKeysByPropertyKey() -> [String: String] {
        return [:]
    }

    static func valueTransformersByPropertyKey() -> [String: NSValueTransformer] {
        return [:]
    }

    static func propertyKeysForManagedObjectUniquing() -> Set<String> {
        return []
    }
}

public extension ManagedObjectSerializing {
    public static var propertyKeys: Set<String> {
        if let cachedKeys = objc_getAssociatedObject(self, &AssociatedKeys.cachedPropertyKeys) as? Set<String> {
            return cachedKeys
        }
        let keys = self.init().propertyKeys
        objc_setAssociatedObject(self, &AssociatedKeys.cachedPropertyKeys, keys, .OBJC_ASSOCIATION_COPY)
        return keys
    }

    public var propertyKeys: Set<String> {
        var keys = [String]()
        var currentMirror = Mirror(reflecting: self)
        while true {
            keys.appendContentsOf(currentMirror.children.flatMap { $0.label })
            if let superMirror = currentMirror.superclassMirror() {
                currentMirror = superMirror
            } else {
                break
            }
        }
        return Set(keys)
    }
}

//public extension ManagedObjectSerializing where Self: AnyObject {
//    public static var propertyKeys: [String] {
//        var count: UInt32 = 0
//        let propertyList = class_copyPropertyList(self, &count)
//        var propertyNames = [String]()
//        for index in 0..<Int(count) {
//            let property: objc_property_t = propertyList[index]
//            if let propertyName = String(UTF8String: property_getName(property)) {
//                propertyNames.append(propertyName)
//            }
//        }
//        return propertyNames
//    }
//}
