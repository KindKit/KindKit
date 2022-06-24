//
//  KindKitUserDefaults
//

import Foundation

public struct UInt16UserDefaultsCoder : IUserDefaultsValueCoder {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> UInt16 {
        return try NSNumberUserDefaultsCoder.decode(value).uint16Value
    }
    
    public static func encode(_ value: UInt16) throws -> IUserDefaultsValue {
        return try NSNumberUserDefaultsCoder.encode(NSNumber(value: value))
    }
    
}

extension UInt16 : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UInt16UserDefaultsCoder
    public typealias UserDefaultsEncoder = UInt16UserDefaultsCoder
    
}
