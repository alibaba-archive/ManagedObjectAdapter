//
//  Event.swift
//  Example
//
//  Created by Xin Hong on 16/7/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import ObjectMapper
import ManagedObjectAdapter

class Event: ModelObject, ManagedObjectSerializing {
    var projectID: String?
    var title: String?
    var isFavorite: Bool?
    var likesCount = 0
    var alert: NSData?
    var recurrence: Recurrence?
    var project: Project?

    override func mapping(map: Map) {
        super.mapping(map)
        projectID <- map["_projectId"]
        title <- map["title"]
        isFavorite <- map["isFavorite"]
        likesCount <- map["_likesCount"]
        alert <- map["alert"]
        recurrence <- map["recurrence"]
        project <- map["project"]
    }

    static func valueTransformersByPropertyKey() -> [String : NSValueTransformer] {
        return ["recurrence": RecurrenceTransformer()]
    }

    static func propertyKeysForManagedObjectUniquing() -> Set<String> {
        return ["id"]
    }

    static func relationshipModelClassesByPropertyKey() -> [String: AnyClass] {
        return ["project": Project.self]
    }
}

@objc(_Event)
class _Event: ManagedObject {
    @NSManaged var alert: NSData?
    @NSManaged var createdAt: NSDate?
    @NSManaged var id: String?
    @NSManaged var isFavorite: NSNumber?
    @NSManaged var likesCount: NSNumber?
    @NSManaged var projectID: String?
    @NSManaged var recurrence: NSObject?
    @NSManaged var title: String?
    @NSManaged var updatedAt: NSDate?
    @NSManaged var project: _Project?
}
