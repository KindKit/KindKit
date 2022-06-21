//
//  KindKitJson
//

import Foundation
import KindKitCore

public extension Json {
    
    @inlinable
    static func parse< Result >(data: Data, _ block: (Json) throws -> Result) throws -> Result {
        guard let json = Json(data: data) else { throw JsonError.notJson }
        return try block(json)
    }
    
    @inlinable
    static func parse< Result >(string: String, encoding: String.Encoding = String.Encoding.utf8, _ block: (Json) throws -> Result) throws -> Result {
        guard let json = Json(string: string, encoding: encoding) else { throw JsonError.notJson }
        return try block(json)
    }
    
}
