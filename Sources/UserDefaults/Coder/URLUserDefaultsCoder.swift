//
//  KindKitUserDefaults
//

import Foundation

public struct URLUserDefaultsCoder : IUserDefaultsValueCoder {
    
    public enum Error : Swift.Error {
        case cast
    }
    
    public static func decode(_ value: IUserDefaultsValue) throws -> URL {
        let string = try NSStringUserDefaultsCoder.decode(value)
        guard let url = URL(string: string as String) else { throw Error.cast }
        return url
    }
    
    public static func encode(_ value: URL) throws -> IUserDefaultsValue {
        return value.absoluteString as NSString
    }
    
}

extension URL : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoderType = URLUserDefaultsCoder
    public typealias UserDefaultsEncoderType = URLUserDefaultsCoder
    
}
