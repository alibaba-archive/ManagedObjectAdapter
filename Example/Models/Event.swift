//
//  Event.swift
//  Example
//
//  Created by Xin Hong on 16/7/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import ObjectMapper

class Event: ModelObject {
    var projectID: String?
    var title: String?
    var isFavorite: Bool?
    var likesCount: Int?
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
}

class _Event: ManagedObject {

}
