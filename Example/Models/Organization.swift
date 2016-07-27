//
//  Organization.swift
//  Example
//
//  Created by Xin Hong on 16/7/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import ObjectMapper

class Organization: ModelObject {
    var name: String?
    var logo: NSURL?
    var teamsCount: Int?
    var projects: [Project]?

    override func mapping(map: Map) {
        super.mapping(map)
        name <- map["name"]
        logo <- (map["logo"], URLTransform())
        teamsCount <- map["_teamsCount"]
        projects <- map["projects"]
    }
}

class _Organization: ManagedObject {

}
