//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct Int : IJsonValueCoder {
        
        public typealias JsonDecoded = Swift.Int
        public typealias JsonEncoded = Swift.Int
        typealias InternalCoder = Json.Coder.NSNumber
        
        public static func decode(_ value: IJsonValue, path: Json.Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.intValue
        }
        
        public static func encode(_ value: JsonEncoded, path: Json.Path) throws -> IJsonValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension Int : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Int
    public typealias JsonEncoder = Json.Coder.Int
    
}
