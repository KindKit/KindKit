//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct Decimal : IJsonValueCoder {
        
        public typealias JsonDecoded = Foundation.Decimal
        public typealias JsonEncoded = Foundation.Decimal
        typealias InternalCoder = Json.Coder.NSDecimalNumber
        
        public static func decode(
            _ value: IJsonValue,
            path: Json.Path
        ) throws -> JsonDecoded {
            let decimal = try InternalCoder.decode(value, path: path)
            return decimal as Foundation.Decimal
        }
        
        public static func encode(_ value: JsonEncoded, path: Json.Path) throws -> IJsonValue {
            let value = Foundation.NSDecimalNumber(decimal: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension Decimal : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Decimal
    public typealias JsonEncoder = Json.Coder.Decimal
    
}
