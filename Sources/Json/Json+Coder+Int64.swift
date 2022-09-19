//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct Int64 : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Swift.Int64 {
            return try Json.Coder.NSNumber.decode(value).int64Value
        }
        
        public static func encode(_ value: Swift.Int64) throws -> IJsonValue {
            return try Json.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Int64 : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Int64
    public typealias JsonEncoder = Json.Coder.Int64
    
}
