//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct Int32 : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Swift.Int32 {
            return try Json.Coder.NSNumber.decode(value).int32Value
        }
        
        public static func encode(_ value: Swift.Int32) throws -> IJsonValue {
            return try Json.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Int32 : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Int32
    public typealias JsonEncoder = Json.Coder.Int32
    
}
