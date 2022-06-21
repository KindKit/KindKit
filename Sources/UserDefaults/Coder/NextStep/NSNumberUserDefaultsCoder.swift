//
//  KindKitUserDefaults
//

import Foundation

public struct NSNumberUserDefaultsCoder : IUserDefaultsValueCoder {
    
    public enum Error : Swift.Error {
        case cast
    }
    
    public static func decode(_ value: IUserDefaultsValue) throws -> NSNumber {
        if let number = value as? NSNumber {
            return number
        } else if let string = value as? NSString, let number = NSNumber.number(from: string) {
            return number
        }
        throw Error.cast
    }
    
    public static func encode(_ value: NSNumber) throws -> IUserDefaultsValue {
        return value
    }
    
}
