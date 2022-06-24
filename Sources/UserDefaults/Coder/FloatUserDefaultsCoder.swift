//
//  KindKitUserDefaults
//

import Foundation

public struct FloatUserDefaultsCoder : IUserDefaultsValueCoder {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> Float {
        return try NSNumberUserDefaultsCoder.decode(value).floatValue
    }
    
    public static func encode(_ value: Float) throws -> IUserDefaultsValue {
        return try NSNumberUserDefaultsCoder.encode(NSNumber(value: value))
    }
    
}

extension Float : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = FloatUserDefaultsCoder
    public typealias UserDefaultsEncoder = FloatUserDefaultsCoder
    
}
