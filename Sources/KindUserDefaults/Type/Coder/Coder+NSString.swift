//
//  KindKit
//

import Foundation

public extension Coder {

    struct NSString : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Foundation.NSString {
            if let string = value as? Foundation.NSString {
                return string
            } else if let number = value as? Foundation.NSNumber {
                return number.stringValue as Foundation.NSString
            } else if let decimalNumber = value as? Foundation.NSDecimalNumber {
                return decimalNumber.stringValue as Foundation.NSString
            }
            throw Error.cast
        }
        
        public static func encode(_ value: Foundation.NSString) throws -> IValue {
            return value
        }
        
    }

}
