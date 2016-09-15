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

class Organization: ModelObject {
    var name: String?
    var logo: URL?
    var teamsCount = 0
    var publicProjects: [Project]?
    var projects: Set<Project>?

    override func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
        logo <- (map["logo"], URLTransform())
        teamsCount <- map["_teamsCount"]
        publicProjects <- map["publicProjects"]
        projects <- map["projects"]
    }

    override class func valueTransformersByPropertyKey() -> [String : ValueTransformer] {
        return ["publicProjects": ArrayValueTransformer<Project>()]
    }

    override class func relationshipModelClassesByPropertyKey() -> [String: AnyClass] {
        return ["projects": Project.self]
    }
}

@objc(_Organization)
class _Organization: ManagedObject {
    @NSManaged var createdAt: Date?
    @NSManaged var id: String?
    @NSManaged var logo: NSObject?
    @NSManaged var name: String?
    @NSManaged var publicProjects: NSObject?
    @NSManaged var teamsCount: NSNumber?
    @NSManaged var updatedAt: Date?
    @NSManaged var projects: NSSet?
}
