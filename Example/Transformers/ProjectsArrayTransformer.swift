//
//  ProjectsArrayTransformer.swift
//  Example
//
//  Created by Xin Hong on 16/8/10.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import ObjectMapper

class ProjectsArrayTransformer: NSValueTransformer {
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        if let object = value as? [Project] {
            let json = Mapper().toJSONArray(object)
            return NSKeyedArchiver.archivedDataWithRootObject(json)
        }
        return nil
    }

    override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        if let data = value as? NSData {
            let json = NSKeyedUnarchiver.unarchiveObjectWithData(data)
            guard let jsonArray = json as? [[String: AnyObject]] else {
                return nil
            }

            let projects = jsonArray.flatMap({ (object) -> Project? in
                return Mapper<Project>().map(object)
            })
            return projects
        }
        return nil
    }
}
