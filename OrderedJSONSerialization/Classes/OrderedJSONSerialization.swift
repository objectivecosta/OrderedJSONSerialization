//
//  OrderedJSONSerialization.swift
//  OrderedJSONSerialization
//
//  Created by Rafael Costa on 28/10/19.
//

import Foundation

public class OrderedJSONSerialization {
    
    public class func data(withJSONObject value: Any?) throws -> Data {
        var jsonStr = [UInt8]()
        
        var writer = JSONWriter(writer: { (str: String?) in
            if let str = str {
                jsonStr.append(contentsOf: str.utf8)
            }
        })
        
        if let container = value as? Array<Any?> {
            try writer.serializeJSON(container)
        } else if let container = value as? Array<(String, Any?)> {
            try writer.serializeJSON(container)
        } else if let container = value as? Dictionary<String, Any> {
            let _container = self.recursivelyTransform(container)
            try writer.serializeJSON(_container)
        } else {
            fatalError("Top-level object was not NSArray or NSDictionary")
        }

        let count = jsonStr.count
        return Data(bytes: &jsonStr, count: count)
    }
    
    private class func recursivelyTransform(_ dictionary: [String : Any]) -> Array<(String, Any?)> {
        var dictionary = dictionary
        for key in Array(dictionary.keys) {
            let value = dictionary[key]
            if let _value = value as? Dictionary<String, Any> {
                dictionary[key] = self.recursivelyTransform(_value)
            } else if let _value = value as? Array<Dictionary<String, Any>> {
                dictionary[key] = _value.map({ self.recursivelyTransform($0) })
            } else {
                dictionary[key] = value
            }
        }

        var result = Array<(String, Any?)>()

        for key in Array(dictionary.keys) {
            result.append((key, dictionary[key]))
        }
        
        return result
    }
}
