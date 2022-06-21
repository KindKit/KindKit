//
//  KindKitUserDefaults
//

import Foundation

public struct UInt8UserDefaultsCoder : IUserDefaultsValueCoder {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> UInt8 {
        return try NSNumberUserDefaultsCoder.decode(value).uint8Value
    }
    
    public static func encode(_ value: UInt8) throws -> IUserDefaultsValue {
        return try NSNumberUserDefaultsCoder.encode(NSNumber(value: value))
    }
    
}

extension UInt8 : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoderType = UInt8UserDefaultsCoder
    public typealias UserDefaultsEncoderType = UInt8UserDefaultsCoder
    
}
