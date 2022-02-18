//
//  KindKitJson
//

import Foundation

public struct NSDecimalNumberJsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> NSDecimalNumber {
        if let decimalNumber = value as? NSDecimalNumber {
            return decimalNumber
        } else if let number = value as? NSNumber {
            return NSDecimalNumber(string: number.stringValue)
        } else if let string = value as? NSString, let decimalNumber = NSDecimalNumber.decimalNumber(from: string) {
            return decimalNumber
        }
        throw JsonError.cast
    }
    
    public static func encode(_ value: NSDecimalNumber) throws -> IJsonValue {
        return value
    }
    
}
