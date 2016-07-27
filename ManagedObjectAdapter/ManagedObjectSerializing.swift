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
    static func relationshipModelClassesByPropertyKey() -> [String: AnyClass]
}

public extension ManagedObjectSerializing {
    public var propertyKeys: [String] {
        return Mirror(reflecting: self).children.flatMap { $0.label }
    }
}

public extension ManagedObjectSerializing where Self: AnyObject {
    public static var propertyKeys: [String] {
        var count: UInt32 = 0
        let propertyList = class_copyPropertyList(self, &count)
        var propertyNames = [String]()
        for index in 0..<Int(count) {
            let property: objc_property_t = propertyList[index]
            if let propertyName = String(UTF8String: property_getName(property)) {
                propertyNames.append(propertyName)
            }
        }
        return propertyNames
    }
}
