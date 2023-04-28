//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct Float : IJsonValueCoder {
        
        public typealias JsonDecoded = Swift.Float
        public typealias JsonEncoded = Swift.Float
        typealias InternalCoder = Json.Coder.NSNumber
        
        public static func decode(_ value: IJsonValue, path: Json.Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.floatValue
        }
        
        public static func encode(_ value: JsonEncoded, path: Json.Path) throws -> IJsonValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension Float : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Float
    public typealias JsonEncoder = Json.Coder.Float
    
}
