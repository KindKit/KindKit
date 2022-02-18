//
//  KindKitJson
//

import Foundation

public struct DecimalJsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> Decimal {
        return try NSDecimalNumberJsonCoder.decode(value) as Decimal
    }
    
    public static func encode(_ value: Decimal) throws -> IJsonValue {
        return try NSDecimalNumberJsonCoder.encode(NSDecimalNumber(decimal: value))
    }
    
}

extension Decimal : IJsonCoderAlias {
    
    public typealias JsonDecoder = DecimalJsonCoder
    public typealias JsonEncoder = DecimalJsonCoder
    
}
