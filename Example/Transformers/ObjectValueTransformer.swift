//
//  ObjectValueTransformer.swift
//  Example
//
//  Created by Xin Hong on 16/8/10.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import ObjectMapper

class ObjectValueTransformer<T: ModelObject>: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        if let value = value as? T {
            let json = value.toJSON()
            return NSKeyedArchiver.archivedData(withRootObject: json)
        }
        return nil
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        if let data = value as? Data {
            let json = NSKeyedUnarchiver.unarchiveObject(with: data)
            return Mapper<T>().map(JSONObject: json)
        }
        return nil
    }
}
