//
//  Organization.swift
//  Example
//
//  Created by Xin Hong on 16/7/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import ObjectMapper
import ManagedObjectAdapter

class Organization: ModelObject, ManagedObjectSerializing {
    var name: String?
    var logo: NSURL?
    var teamsCount = 0
    var publicProjects: [Project]?
    var projects: Set<Project>?

    override func mapping(map: Map) {
        super.mapping(map)
        name <- map["name"]
        logo <- (map["logo"], URLTransform())
        teamsCount <- map["_teamsCount"]
        publicProjects <- map["publicProjects"]
        projects <- map["projects"]
    }

    static func valueTransformersByPropertyKey() -> [String : NSValueTransformer] {
        return ["publicProjects": ProjectsArrayTransformer()]
    }

    static func propertyKeysForManagedObjectUniquing() -> Set<String> {
        return ["id"]
    }

    static func relationshipModelClassesByPropertyKey() -> [String: AnyClass] {
        return ["projects": Project.self]
    }
}

@objc(_Organization)
class _Organization: ManagedObject {
    @NSManaged var createdAt: NSDate?
    @NSManaged var id: String?
    @NSManaged var logo: NSObject?
    @NSManaged var name: String?
    @NSManaged var publicProjects: NSObject?
    @NSManaged var teamsCount: NSNumber?
    @NSManaged var updatedAt: NSDate?
    @NSManaged var projects: NSSet?
}
