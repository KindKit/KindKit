//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct UInt16 : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Swift.UInt16 {
            return try Json.Coder.NSNumber.decode(value).uint16Value
        }
        
        public static func encode(_ value: Swift.UInt16) throws -> IJsonValue {
            return try Json.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension UInt16 : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.UInt16
    public typealias JsonEncoder = Json.Coder.UInt16
    
}
