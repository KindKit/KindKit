//
//  KindKitUserDefaults
//

import Foundation

public struct DateUserDefaultsCoder : IUserDefaultsValueCoder {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> Date {
        let number = try NSNumberUserDefaultsCoder.decode(value)
        return Date(timeIntervalSince1970: number.doubleValue)
    }
    
    public static func encode(_ value: Date) throws -> IUserDefaultsValue {
        return try NSNumberUserDefaultsCoder.encode(NSNumber(value: Int(value.timeIntervalSince1970)))
    }
    
}

extension Date : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoderType = DateUserDefaultsCoder
    public typealias UserDefaultsEncoderType = DateUserDefaultsCoder
    
}
