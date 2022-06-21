//
//  KindKitJson
//

import Foundation
import KindKitCore

public enum JsonError : Error {
    case notJson
    case access
    case cast
}

public final class Json {

    public internal(set) var root: IJsonValue?

    public init() {
    }

    public init(root: IJsonValue) {
        self.root = root
    }

    public init?(data: Data) {
        guard let root = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
        self.root = (root as! IJsonValue)
    }

    public init?(string: String, encoding: String.Encoding = String.Encoding.utf8) {
        guard let data = string.data(using: String.Encoding.utf8) else { return nil }
        guard let root = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
        self.root = (root as! IJsonValue)
    }
    
}

public extension Json {
    
    var isDictionary: Bool {
        return self.root is NSDictionary
    }
    
    var isArray: Bool {
        return self.root is NSArray
    }
    
    func dictionary() throws -> NSDictionary {
        guard let dictionary = self.root as? NSDictionary else { throw JsonError.notJson }
        return dictionary
    }
    
    func array() throws -> NSArray {
        guard let array = self.root as? NSArray else { throw JsonError.notJson }
        return array
    }
    
}

public extension Json {

    func saveAsData(options: JSONSerialization.WritingOptions = []) throws -> Data {
        guard let root = self.root else { throw JsonError.notJson }
        return try JSONSerialization.data(withJSONObject: root, options: options)
    }

    func saveAsString(encoding: String.Encoding = String.Encoding.utf8, options: JSONSerialization.WritingOptions = []) throws -> String? {
        return String(data: try self.saveAsData(options: options), encoding: encoding)
    }
    
}

public extension Json {
    
    func get() throws -> IJsonValue {
        return try self._get(path: nil)
    }
    
    func get(path: String) throws -> IJsonValue {
        return try self._get(path: path)
    }

    func set(value: IJsonValue) throws {
        try self._set(value: value, path: nil)
    }
    
    func set(value: IJsonValue, path: String) throws {
        try self._set(value: value, path: path)
    }

    func remove(path: String) throws {
        try self._set(value: nil, path: path)
    }
    
    func clean() {
        self.root = nil
    }
    
}
