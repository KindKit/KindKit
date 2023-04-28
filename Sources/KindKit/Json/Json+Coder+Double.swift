//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct Double : IJsonValueCoder {
        
        public typealias JsonDecoded = Swift.Double
        public typealias JsonEncoded = Swift.Double
        typealias InternalCoder = Json.Coder.NSNumber
        
        public static func decode(_ value: IJsonValue, path: Json.Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.doubleValue
        }
        
        public static func encode(_ value: JsonEncoded, path: Json.Path) throws -> IJsonValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension Double : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Double
    public typealias JsonEncoder = Json.Coder.Double
    
}
