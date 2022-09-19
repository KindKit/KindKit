//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct Decimal : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Foundation.Decimal {
            return try Json.Coder.NSDecimalNumber.decode(value) as Foundation.Decimal
        }
        
        public static func encode(_ value: Foundation.Decimal) throws -> IJsonValue {
            return try Json.Coder.NSDecimalNumber.encode(Foundation.NSDecimalNumber(decimal: value))
        }
        
    }
    
}

extension Decimal : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Decimal
    public typealias JsonEncoder = Json.Coder.Decimal
    
}
