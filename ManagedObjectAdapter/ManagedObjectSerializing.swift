//
//  ManagedObjectSerializing.swift
//  ManagedObjectAdapter
//
//  Created by Xin Hong on 16/7/27.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

public protocol ManagedObjectSerializing {
    init()
    static func managedObjectEntityName() -> String
    static func managedObjectKeysByPropertyKey() -> [String: String]
    static func relationshipModelClassesByPropertyKey() -> [String: AnyClass]
}

public extension ManagedObjectSerializing where Self: AnyObject {
    static func managedObjectEntityName() -> String {
        return String(self)
    }

    static func managedObjectKeysByPropertyKey() -> [String: String] {
        var managedObjectKeys = [String: String]()
        for property in propertyKeys {
            managedObjectKeys.updateValue(property, forKey: property)
        }
        return managedObjectKeys
    }

    static func relationshipModelClassesByPropertyKey() -> [String: AnyClass] {
        return [:]
    }
}

internal struct AssociatedKeys {
    static var cachedPropertyKeys = "ManagedObjectAdapterCachedPropertyKeys"
}

public extension ManagedObjectSerializing where Self: AnyObject {
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
