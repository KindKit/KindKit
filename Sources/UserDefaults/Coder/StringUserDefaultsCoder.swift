//
//  KindKitUserDefaults
//

import Foundation

public struct StringUserDefaultsCoder : IUserDefaultsValueCoder {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> String {
        return try NSStringUserDefaultsCoder.decode(value) as String
    }
    
    public static func encode(_ value: String) throws -> IUserDefaultsValue {
        return try NSStringUserDefaultsCoder.encode(NSString(string: value))
    }
    
}

public struct NonEmptyStringUserDefaultsDecoder : IUserDefaultsValueDecoder {
    
    public enum Error : Swift.Error {
        case cast
    }
    
    public static func decode(_ value: IUserDefaultsValue) throws -> String {
        let string = try StringUserDefaultsCoder.decode(value)
        if string.isEmpty == true {
            throw Error.cast
        }
        return string
    }
    
}

extension String : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoderType = StringUserDefaultsCoder
    public typealias UserDefaultsEncoderType = StringUserDefaultsCoder
    
}
