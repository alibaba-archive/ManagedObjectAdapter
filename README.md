# ManagedObjectAdapter
[![Build Status](https://travis-ci.org/teambition/ManagedObjectAdapter.svg?branch=master)](https://travis-ci.org/teambition/ManagedObjectAdapter)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

ManagedObjectAdapter is a lightweight adapter for the converts between Model instances and Core Data managed objects.

## How To Get Started
### Carthage
Specify "ManagedObjectAdapter" in your ```Cartfile```:
```ogdl 
github "teambition/ManagedObjectAdapter"
```

### Usage
Models that you want to use ManagedObjectAdapter must conform to ```ManagedObjectSerializing``` protocol.

```swift
protocol ManagedObjectSerializing {
    init()
    func value(forKey key: String) -> Any?
    func setValue(_ value: Any?, forKey key: String)

    static func managedObjectEntityName() -> String
    static func managedObjectKeysByPropertyKey() -> [String: String]
    static func valueTransformersByPropertyKey() -> [String: ValueTransformer]
    static func relationshipModelClassesByPropertyKey() -> [String: AnyClass]
    static func propertyKeysForManagedObjectUniquing() -> Set<String>
}
```

You can use ManagedObjectAdapter like this:

```swift
class TestModel: NSObject, ManagedObjectSerializing {
    var id: String?

    // Property name of this property in xcdatamodeld is "downloadUrl"
    var downloadURL: URL?

    // Type of this property in xcdatamodeld is Transformable
    var transformableModel: TransformableModel?

    // Type of this property in xcdatamodeld is to many relationship
    var relationshipModels: Set<RelationshipModel>?

    required override init() { }

    static func managedObjectKeysByPropertyKey() -> [String: String] {
        return ["downloadURL": "downloadUrl"]
    }

    static func valueTransformersByPropertyKey() -> [String : ValueTransformer] {
        return ["transformableModel": TransformableModelTransformer()]
    }

    static func propertyKeysForManagedObjectUniquing() -> Set<String> {
        return ["id"]
    }

    static func relationshipModelClassesByPropertyKey() -> [String: AnyClass] {
        return ["relationshipModels": RelationshipModel.self]
    }
}

class TransformableModel: NSObject, ManagedObjectSerializing {
    var id: String?

    required override init() { }
}

class RelationshipModel: NSObject, ManagedObjectSerializing {
    var id: String?

    required override init() { }
}

class TransformableModelTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        // Model to Data
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        // Data to Model
    }
}

let managedObjectContext = ...
let originModel = ...
let moTestModel = originModel.toManagedObject(in: managedObjectContext)
let testModel = TestModel.model(from: moTestModel!)
```

## Minimum Requirement
iOS 8.0

## Release Notes
* [Release Notes](https://github.com/teambition/ManagedObjectAdapter/releases)

## License
ManagedObjectAdapter is released under the MIT license. See [LICENSE](https://github.com/teambition/ManagedObjectAdapter/blob/master/LICENSE) for details.

## More Info
Have a question? Please [open an issue](https://github.com/teambition/ManagedObjectAdapter/issues/new)!
