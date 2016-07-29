//
//  Project.swift
//  Example
//
//  Created by Xin Hong on 16/7/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import ObjectMapper

class Project: ModelObject {
    var name: String?
    var logo: NSURL?
    var isPublic: Bool?
    var isStar: Bool?
    var unreadCount = 0
    var organization: Organization?
    var events: [Event]?

    override func mapping(map: Map) {
        super.mapping(map)
        name <- map["name"]
        logo <- (map["logo"], URLTransform())
        isStar <- map["isStar"]
        isPublic <- map["isPublic"]
        unreadCount <- map["_unreadCount"]
        organization <- map["organization"]
        events <- map["events"]
    }
}

@objc(_Project)
class _Project: ManagedObject {

}
