//
//  ArrayValueTransformer.swift
//  Example
//
//  Created by Xin Hong on 16/8/10.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import ObjectMapper

class ArrayValueTransformer<T: ModelObject>: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        if let value = value as? [T] {
            let jsonArray = value.toJSON()
            return NSKeyedArchiver.archivedData(withRootObject: jsonArray)
        }
        return nil
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        if let data = value as? Data {
            guard let jsonArray = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Any] else {
                return nil
            }
            return jsonArray.flatMap { Mapper<T>().map(JSONObject: $0) }
        }
        return nil
    }
}

