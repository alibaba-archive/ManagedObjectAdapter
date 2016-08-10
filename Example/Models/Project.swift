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
}

@objc(_Project)
class _Project: ManagedObject {

}
