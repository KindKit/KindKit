//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct Int8 : IJsonValueCoder {
        
        public typealias JsonDecoded = Swift.Int8
        public typealias JsonEncoded = Swift.Int8
        typealias InternalCoder = Json.Coder.NSNumber
        
        public static func decode(_ value: IJsonValue, path: Json.Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.int8Value
        }
        
        public static func encode(_ value: JsonEncoded, path: Json.Path) throws -> IJsonValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension Int8 : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Int8
    public typealias JsonEncoder = Json.Coder.Int8
    
}
