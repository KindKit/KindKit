//
//  KindKitJson
//

import Foundation

public struct NSStringJsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> NSString {
        if let string = value as? NSString {
            return string
        } else if let number = value as? NSNumber {
            return number.stringValue as NSString
        } else if let decimalNumber = value as? NSDecimalNumber {
            return decimalNumber.stringValue as NSString
        }
        throw JsonError.cast
    }
    
    public static func encode(_ value: NSString) throws -> IJsonValue {
        return value
    }
    
}
