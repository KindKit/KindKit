//
//  KindKitUserDefaults
//

import Foundation

public struct UInt64UserDefaultsCoder : IUserDefaultsValueCoder {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> UInt64 {
        return try NSNumberUserDefaultsCoder.decode(value).uint64Value
    }
    
    public static func encode(_ value: UInt64) throws -> IUserDefaultsValue {
        return try NSNumberUserDefaultsCoder.encode(NSNumber(value: value))
    }
    
}

extension UInt64 : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UInt64UserDefaultsCoder
    public typealias UserDefaultsEncoder = UInt64UserDefaultsCoder
    
}
