//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct NSString : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Foundation.NSString {
            if let string = value as? Foundation.NSString {
                return string
            } else if let number = value as? Foundation.NSNumber {
                return number.stringValue as Foundation.NSString
            } else if let decimalNumber = value as? Foundation.NSDecimalNumber {
                return decimalNumber.stringValue as Foundation.NSString
            }
            throw Json.Error.cast
        }
        
        public static func encode(_ value: Foundation.NSString) throws -> IJsonValue {
            return value
        }
        
    }

}
