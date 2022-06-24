//
//  KindKitUserDefaults
//

import Foundation

public struct UIntUserDefaultsCoder : IUserDefaultsValueCoder {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> UInt {
        return try NSNumberUserDefaultsCoder.decode(value).uintValue
    }
    
    public static func encode(_ value: UInt) throws -> IUserDefaultsValue {
        return try NSNumberUserDefaultsCoder.encode(NSNumber(value: value))
    }
    
}

extension UInt : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UIntUserDefaultsCoder
    public typealias UserDefaultsEncoder = UIntUserDefaultsCoder
    
}
