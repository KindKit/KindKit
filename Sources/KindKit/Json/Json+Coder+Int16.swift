//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct Int16 : IJsonValueCoder {
        
        public typealias JsonDecoded = Swift.Int16
        public typealias JsonEncoded = Swift.Int16
        typealias InternalCoder = Json.Coder.NSNumber
        
        public static func decode(_ value: IJsonValue, path: Json.Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.int16Value
        }
        
        public static func encode(_ value: JsonEncoded, path: Json.Path) throws -> IJsonValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension Int16 : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Int16
    public typealias JsonEncoder = Json.Coder.Int16
    
}
