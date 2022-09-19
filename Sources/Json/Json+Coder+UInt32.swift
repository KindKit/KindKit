//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct UInt32 : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Swift.UInt32 {
            return try Json.Coder.NSNumber.decode(value).uint32Value
        }
        
        public static func encode(_ value: Swift.UInt32) throws -> IJsonValue {
            return try Json.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension UInt32 : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.UInt32
    public typealias JsonEncoder = Json.Coder.UInt32
    
}
