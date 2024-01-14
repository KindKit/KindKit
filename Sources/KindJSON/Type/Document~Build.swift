//
//  KindKit
//

import Foundation

public extension Document {
    
    @inlinable
    static func build(_ block: (Document) throws -> Void) throws -> Document {
        let json = Document(path: .root)
        try block(json)
        return json
    }
    
    @inlinable
    static func build(_ block: (Document) throws -> Void) throws -> Data {
        return try Self.build(block).asData()
    }
    
}
