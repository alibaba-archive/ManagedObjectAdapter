//
//  ModelObject.swift
//  Example
//
//  Created by Xin Hong on 16/7/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import ObjectMapper
import ManagedObjectAdapter

@objcMembers
class ModelObject: NSObject, Mappable, ManagedObjectSerializing {
    var id: String?
    var createdAt: Date?
    var updatedAt: Date?

    required override init() {
        super.init()
    }

    required init?(map: Map) {

    }

    convenience init?(_ JSON: Any?) {
        self.init()
        if let JSON = JSON as? [String: Any] {
            let map = Map(mappingType: .fromJSON, JSON: JSON)
            mapping(map: map)
        } else {
            return nil
        }
    }

    func mapping(map: Map) {
        id <- map["_id"]
        createdAt <- (map["created"], DateTransform())
        updatedAt <- (map["updated"], DateTransform())
    }

    class func managedObjectKeysByPropertyKey() -> [String: String] {
        return [:]
    }

    class func valueTransformersByPropertyKey() -> [String: ValueTransformer] {
        return [:]
    }

    class func relationshipModelClassesByPropertyKey() -> [String: AnyClass] {
        return [:]
    }

    class func propertyKeysForManagedObjectUniquing() -> Set<String> {
        return ["id"]
    }
}

class DateTransform: DateFormatterTransform {
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        super.init(dateFormatter: dateFormatter)
    }
}
