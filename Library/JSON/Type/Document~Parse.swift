//
//  KindKit
//

import Foundation

public extension Document {
    
    convenience init(
        in path: Path = .root,
        data: Data
    ) throws(ParseError) {
        guard let root = try? JSONSerialization.jsonObject(with: data, options: []) else {
            throw ParseError.notJson
        }
        self.init(in: path, root: root as! Field)
    }
    
    convenience init(
        in path: Path = .root,
        string: String,
        encoding: String.Encoding = .utf8
    ) throws(ParseError) {
        guard let data = string.data(using: encoding) else {
            throw ParseError.notJson
        }
        try self.init(in: path, data: data)
    }
    
}

public extension Document {
    
    @inlinable
    static func parse< Result >(
        in path: Path = .root,
        data: Data,
        decode: (Document) throws -> Result
    ) throws -> Result {
        let json = try Document(in: path, data: data)
        return try decode(json)
    }
    
    @inlinable
    static func parse< Result >(
        in path: Path = .root,
        string: String,
        encoding: String.Encoding = .utf8,
        decode: (Document) throws -> Result
    ) throws -> Result {
        let json = try Document(in: path, string: string, encoding: encoding)
        return try decode(json)
    }
    
    @inlinable
    static func parse< Result >(
        in path: Path = .root,
        contentsOf: URL,
        decode: (Document) throws -> Result
    ) throws -> Result {
        guard let data = try? Data(contentsOf: contentsOf) else {
            throw ParseError.notJson
        }
        return try self.parse(in: path, data: data, decode: decode)
    }
    
}
