//
//  KindKitUserDefaults
//

import Foundation

public struct Int32UserDefaultsCoder : IUserDefaultsValueCoder {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> Int32 {
        return try NSNumberUserDefaultsCoder.decode(value).int32Value
    }
    
    public static func encode(_ value: Int32) throws -> IUserDefaultsValue {
        return try NSNumberUserDefaultsCoder.encode(NSNumber(value: value))
    }
    
}

extension Int32 : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = Int32UserDefaultsCoder
    public typealias UserDefaultsEncoder = Int32UserDefaultsCoder
    
}
