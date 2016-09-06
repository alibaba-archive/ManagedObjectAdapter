//
//  Recurrence.swift
//  Example
//
//  Created by Xin Hong on 16/7/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import ObjectMapper
import ManagedObjectAdapter

class Recurrence: ModelObject {
    var rule: String?
    var count = 0

    override func mapping(map: Map) {
        super.mapping(map)
        rule <- map["rule"]
        count <- map["count"]
    }
}
