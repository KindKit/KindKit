//
//  KindKitUserDefaults
//

import Foundation

public struct BoolUserDefaultsCoder : IUserDefaultsValueCoder {
    
    public enum Error : Swift.Error {
        case cast
    }
    
    public static func decode(_ value: IUserDefaultsValue) throws -> Bool {
        if let number = value as? NSNumber {
            return number.boolValue
        } else if let string = value as? NSString {
            switch string.lowercased {
            case "true", "yes", "on": return true
            case "false", "no", "off": return false
            default: break
            }
        }
        throw Error.cast
    }
    
    public static func encode(_ value: Bool) throws -> IUserDefaultsValue {
        return NSNumber(value: value)
    }
    
}

extension Bool : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoderType = BoolUserDefaultsCoder
    public typealias UserDefaultsEncoderType = BoolUserDefaultsCoder
    
}
