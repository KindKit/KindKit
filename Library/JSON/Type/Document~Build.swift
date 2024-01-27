//
//  KindKit
//

import Foundation

public extension Document {
    
    @inlinable
    static func build(document block: (Document) throws -> Void) throws -> Document {
        let json = Document(in: .root)
        try block(json)
        return json
    }
    
    @inlinable
    static func build(data block: (Document) throws -> Void) throws -> Data {
        return try Self.build(document: block).asData()
    }
    
}
