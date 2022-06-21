//
//  KindKitUserDefaults
//

import Foundation

public struct Int16UserDefaultsCoder : IUserDefaultsValueCoder {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> Int16 {
        return try NSNumberUserDefaultsCoder.decode(value).int16Value
    }
    
    public static func encode(_ value: Int16) throws -> IUserDefaultsValue {
        return try NSNumberUserDefaultsCoder.encode(NSNumber(value: value))
    }
    
}

extension Int16 : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoderType = Int16UserDefaultsCoder
    public typealias UserDefaultsEncoderType = Int16UserDefaultsCoder
    
}
