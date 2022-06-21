//
//  KindKitUserDefaults
//

import Foundation

public struct NSDecimalNumberUserDefaultsCoder : IUserDefaultsValueCoder {
    
    public enum Error : Swift.Error {
        case cast
    }
    
    public static func decode(_ value: IUserDefaultsValue) throws -> NSDecimalNumber {
        if let decimalNumber = value as? NSDecimalNumber {
            return decimalNumber
        } else if let number = value as? NSNumber {
            return NSDecimalNumber(string: number.stringValue)
        } else if let string = value as? NSString, let decimalNumber = NSDecimalNumber.decimalNumber(from: string) {
            return decimalNumber
        }
        throw Error.cast
    }
    
    public static func encode(_ value: NSDecimalNumber) throws -> IUserDefaultsValue {
        return value
    }
    
}
