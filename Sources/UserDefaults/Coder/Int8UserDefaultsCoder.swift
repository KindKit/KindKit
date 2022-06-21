//
//  KindKitUserDefaults
//

import Foundation

public struct Int8UserDefaultsCoder : IUserDefaultsValueCoder {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> Int8 {
        return try NSNumberUserDefaultsCoder.decode(value).int8Value
    }
    
    public static func encode(_ value: Int8) throws -> IUserDefaultsValue {
        return try NSNumberUserDefaultsCoder.encode(NSNumber(value: value))
    }
    
}

extension Int8 : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoderType = Int8UserDefaultsCoder
    public typealias UserDefaultsEncoderType = Int8UserDefaultsCoder
    
}
