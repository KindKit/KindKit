//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct Int16 : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Swift.Int16 {
            return try Json.Coder.NSNumber.decode(value).int16Value
        }
        
        public static func encode(_ value: Swift.Int16) throws -> IJsonValue {
            return try Json.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Int16 : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Int16
    public typealias JsonEncoder = Json.Coder.Int16
    
}
