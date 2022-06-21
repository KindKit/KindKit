//
//  KindKitUserDefaults
//

import Foundation

public struct DoubleUserDefaultsCoder : IUserDefaultsValueCoder {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> Double {
        return try NSNumberUserDefaultsCoder.decode(value).doubleValue
    }
    
    public static func encode(_ value: Double) throws -> IUserDefaultsValue {
        return try NSNumberUserDefaultsCoder.encode(NSNumber(value: value))
    }
    
}

extension Double : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoderType = DoubleUserDefaultsCoder
    public typealias UserDefaultsEncoderType = DoubleUserDefaultsCoder
    
}
