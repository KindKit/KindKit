//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct UInt8 : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Swift.UInt8 {
            return try Json.Coder.NSNumber.decode(value).uint8Value
        }
        
        public static func encode(_ value: Swift.UInt8) throws -> IJsonValue {
            return try Json.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension UInt8 : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.UInt8
    public typealias JsonEncoder = Json.Coder.UInt8
    
}
