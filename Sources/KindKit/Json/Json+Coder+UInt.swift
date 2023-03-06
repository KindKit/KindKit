//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct UInt : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Swift.UInt {
            return try Json.Coder.NSNumber.decode(value).uintValue
        }
        
        public static func encode(_ value: Swift.UInt) throws -> IJsonValue {
            return try Json.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension UInt : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.UInt
    public typealias JsonEncoder = Json.Coder.UInt
    
}
