//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct Int8 : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Swift.Int8 {
            return try Json.Coder.NSNumber.decode(value).int8Value
        }
        
        public static func encode(_ value: Swift.Int8) throws -> IJsonValue {
            return try Json.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Int8 : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Int8
    public typealias JsonEncoder = Json.Coder.Int8
    
}
