//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct UInt : IJsonValueCoder {
        
        public typealias JsonDecoded = Swift.UInt
        public typealias JsonEncoded = Swift.UInt
        typealias InternalCoder = Json.Coder.NSNumber
        
        public static func decode(_ value: IJsonValue, path: Json.Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.uintValue
        }
        
        public static func encode(_ value: JsonEncoded, path: Json.Path) throws -> IJsonValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension UInt : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.UInt
    public typealias JsonEncoder = Json.Coder.UInt
    
}
