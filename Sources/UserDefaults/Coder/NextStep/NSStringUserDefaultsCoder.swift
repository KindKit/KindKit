//
//  KindKitUserDefaults
//

import Foundation

public struct NSStringUserDefaultsCoder : IUserDefaultsValueCoder {
    
    public enum Error : Swift.Error {
        case cast
    }
    
    public static func decode(_ value: IUserDefaultsValue) throws -> NSString {
        if let string = value as? NSString {
            return string
        } else if let number = value as? NSNumber {
            return number.stringValue as NSString
        } else if let decimalNumber = value as? NSDecimalNumber {
            return decimalNumber.stringValue as NSString
        }
        throw Error.cast
    }
    
    public static func encode(_ value: NSString) throws -> IUserDefaultsValue {
        return value
    }
    
}
