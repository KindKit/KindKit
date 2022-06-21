//
//  KindKitUserDefaults
//

import Foundation

public struct Int64UserDefaultsCoder : IUserDefaultsValueCoder {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> Int64 {
        return try NSNumberUserDefaultsCoder.decode(value).int64Value
    }
    
    public static func encode(_ value: Int64) throws -> IUserDefaultsValue {
        return try NSNumberUserDefaultsCoder.encode(NSNumber(value: value))
    }
    
}

extension Int64 : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoderType = Int64UserDefaultsCoder
    public typealias UserDefaultsEncoderType = Int64UserDefaultsCoder
    
}
