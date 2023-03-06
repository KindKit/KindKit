//
//  KindKit
//

import Foundation

public extension Json {
    
    @inlinable
    static func build(_ block: (Json) throws -> Void) throws -> Data {
        let json = Json()
        try block(json)
        return try json.saveAsData()
    }
    
}
