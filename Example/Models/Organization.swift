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
    var projects: [Project]?

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
}

@objc(_Organization)
class _Organization: ManagedObject {

}
