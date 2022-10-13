//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct NSNumber : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Foundation.NSNumber {
            if let number = value as? Foundation.NSNumber {
                return number
            } else if let string = value as? Foundation.NSString, let number = Foundation.NSNumber.kk_number(from: string) {
                return number
            }
            throw UserDefaults.Error.cast
        }
        
        public static func encode(_ value: Foundation.NSNumber) throws -> IUserDefaultsValue {
            return value
        }
        
    }

}
