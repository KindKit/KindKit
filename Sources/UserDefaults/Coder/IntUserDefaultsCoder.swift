//
//  KindKitUserDefaults
//

import Foundation

public struct IntUserDefaultsCoder : IUserDefaultsValueCoder {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> Int {
        return try NSNumberUserDefaultsCoder.decode(value).intValue
    }
    
    public static func encode(_ value: Int) throws -> IUserDefaultsValue {
        return try NSNumberUserDefaultsCoder.encode(NSNumber(value: value))
    }
    
}

extension Int : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoderType = IntUserDefaultsCoder
    public typealias UserDefaultsEncoderType = IntUserDefaultsCoder
    
}
