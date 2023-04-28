//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct UInt8 : IJsonValueCoder {
        
        public typealias JsonDecoded = Swift.UInt8
        public typealias JsonEncoded = Swift.UInt8
        typealias InternalCoder = Json.Coder.NSNumber
        
        public static func decode(_ value: IJsonValue, path: Json.Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.uint8Value
        }
        
        public static func encode(_ value: JsonEncoded, path: Json.Path) throws -> IJsonValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension UInt8 : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.UInt8
    public typealias JsonEncoder = Json.Coder.UInt8
    
}
