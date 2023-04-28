//
//  KindKit
//

import Foundation

public extension Json {
    
    convenience init(
        path: Json.Path = .root,
        data: Data
    ) throws {
        guard let root = try? JSONSerialization.jsonObject(with: data, options: []) else {
            throw Json.Error.Parse.notJson
        }
        self.init(path: path, root: root as! IJsonValue)
    }
    
    convenience init(
        path: Json.Path = .root,
        string: String,
        encoding: String.Encoding = .utf8
    ) throws {
        guard let data = string.data(using: encoding) else {
            throw Json.Error.Parse.notJson
        }
        try self.init(path: path, data: data)
    }
    
}

public extension Json {
    
    @inlinable
    static func parse< Result >(
        path: Json.Path = .root,
        data: Data,
        decode: (Json) throws -> Result
    ) throws -> Result {
        let json = try Json(path: path, data: data)
        return try decode(json)
    }
    
    @inlinable
    static func parse< Result >(
        path: Json.Path = .root,
        string: String,
        encoding: String.Encoding = .utf8,
        decode: (Json) throws -> Result
    ) throws -> Result {
        let json = try Json(path: path, string: string, encoding: encoding)
        return try decode(json)
    }
    
}
