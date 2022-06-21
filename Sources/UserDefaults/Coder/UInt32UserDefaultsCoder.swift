//
//  KindKitUserDefaults
//

import Foundation

public struct UInt32UserDefaultsCoder : IUserDefaultsValueCoder {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> UInt32 {
        return try NSNumberUserDefaultsCoder.decode(value).uint32Value
    }
    
    public static func encode(_ value: UInt32) throws -> IUserDefaultsValue {
        return try NSNumberUserDefaultsCoder.encode(NSNumber(value: value))
    }
    
}

extension UInt32 : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoderType = UInt32UserDefaultsCoder
    public typealias UserDefaultsEncoderType = UInt32UserDefaultsCoder
    
}
