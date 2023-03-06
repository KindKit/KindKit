//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct UInt64 : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Swift.UInt64 {
            return try Json.Coder.NSNumber.decode(value).uint64Value
        }
        
        public static func encode(_ value: Swift.UInt64) throws -> IJsonValue {
            return try Json.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension UInt64 : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.UInt64
    public typealias JsonEncoder = Json.Coder.UInt64
    
}
