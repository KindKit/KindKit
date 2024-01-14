//
//  KindKit
//

import Foundation

public extension Document {
    
    convenience init(
        path: Path = .root,
        data: Data
    ) throws {
        guard let root = try? JSONSerialization.jsonObject(with: data, options: []) else {
            throw Error.Parse.notJson
        }
        self.init(path: path, root: root as! IValue)
    }
    
    convenience init(
        path: Path = .root,
        string: String,
        encoding: String.Encoding = .utf8
    ) throws {
        guard let data = string.data(using: encoding) else {
            throw Error.Parse.notJson
        }
        try self.init(path: path, data: data)
    }
    
}

public extension Document {
    
    @inlinable
    static func parse< Result >(
        path: Path = .root,
        data: Data,
        decode: (Document) throws -> Result
    ) throws -> Result {
        let json = try Document(path: path, data: data)
        return try decode(json)
    }
    
    @inlinable
    static func parse< Result >(
        path: Path = .root,
        string: String,
        encoding: String.Encoding = .utf8,
        decode: (Document) throws -> Result
    ) throws -> Result {
        let json = try Document(path: path, string: string, encoding: encoding)
        return try decode(json)
    }
    
    @inlinable
    static func parse< Result >(
        path: Path = .root,
        contentsOf: URL,
        decode: (Document) throws -> Result
    ) throws -> Result {
        guard let data = try? Data(contentsOf: contentsOf) else {
            throw Error.Parse.notJson
        }
        return try self.parse(path: path, data: data, decode: decode)
    }
    
}
