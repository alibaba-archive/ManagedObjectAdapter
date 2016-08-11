//
//  Project.swift
//  Example
//
//  Created by Xin Hong on 16/7/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import ObjectMapper
import ManagedObjectAdapter

class Project: ModelObject, ManagedObjectSerializing {
    var name: String?
    var logo: NSURL?
    var isPublic: Bool = false
    var isStar: Bool = false
    var unreadCount = 0
    var org: Organization?
    var organization: Organization?
    var events: [Event]?

    override func mapping(map: Map) {
        super.mapping(map)
        name <- map["name"]
        logo <- (map["logo"], URLTransform())
        isStar <- map["isStar"]
        isPublic <- map["isPublic"]
        unreadCount <- map["_unreadCount"]
        org <- map["org"]
        organization <- map["organization"]
        events <- map["events"]
    }

    static func valueTransformersByPropertyKey() -> [String : NSValueTransformer] {
        return ["org": OrignizationTransformer()]
    }

    static func propertyKeysForManagedObjectUniquing() -> Set<String> {
        return ["id"]
    }

    static func relationshipModelClassesByPropertyKey() -> [String: AnyClass] {
        return ["organization": Organization.self, "events": Event.self]
    }
}

@objc(_Project)
class _Project: ManagedObject {
    @NSManaged var createdAt: NSDate?
    @NSManaged var id: String?
    @NSManaged var isPublic: NSNumber?
    @NSManaged var isStar: NSNumber?
    @NSManaged var logo: NSObject?
    @NSManaged var name: String?
    @NSManaged var org: NSObject?
    @NSManaged var unreadCount: NSNumber?
    @NSManaged var updatedAt: NSDate?
    @NSManaged var events: NSSet?
    @NSManaged var organization: _Organization?
}
