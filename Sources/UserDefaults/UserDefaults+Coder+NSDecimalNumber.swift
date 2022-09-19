//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct NSDecimalNumber : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Foundation.NSDecimalNumber {
            if let decimalNumber = value as? Foundation.NSDecimalNumber {
                return decimalNumber
            } else if let number = value as? Foundation.NSNumber {
                return .init(string: number.stringValue)
            } else if let string = value as? Foundation.NSString, let decimalNumber = Foundation.NSDecimalNumber.decimalNumber(from: string) {
                return decimalNumber
            }
            throw UserDefaults.Error.cast
        }
        
        public static func encode(_ value: Foundation.NSDecimalNumber) throws -> IUserDefaultsValue {
            return value
        }
        
    }

}
