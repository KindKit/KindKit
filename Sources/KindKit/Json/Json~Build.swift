//
//  KindKit
//

import Foundation

public extension Json {
    
    @inlinable
    static func build(_ block: (Json) throws -> Void) throws -> Json {
        let json = Json(path: .root)
        try block(json)
        return json
    }
    
    @inlinable
    static func build(_ block: (Json) throws -> Void) throws -> Data {
        return try Self.build(block).asData()
    }
    
}
