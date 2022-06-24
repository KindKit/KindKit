//
//  KindKitUserDefaults
//

import Foundation

public struct DecimalUserDefaultsCoder : IUserDefaultsValueCoder {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> Decimal {
        return try NSDecimalNumberUserDefaultsCoder.decode(value) as Decimal
    }
    
    public static func encode(_ value: Decimal) throws -> IUserDefaultsValue {
        return try NSDecimalNumberUserDefaultsCoder.encode(NSDecimalNumber(decimal: value))
    }
    
}

extension Decimal : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = DecimalUserDefaultsCoder
    public typealias UserDefaultsEncoder = DecimalUserDefaultsCoder
    
}
