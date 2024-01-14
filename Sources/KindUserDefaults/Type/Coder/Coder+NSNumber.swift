//
//  KindKit
//

import Foundation

public extension Coder {

    struct NSNumber : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Foundation.NSNumber {
            if let number = value as? Foundation.NSNumber {
                return number
            } else if let string = value as? Foundation.NSString, let number = Foundation.NSNumber.kk_number(from: string) {
                return number
            }
            throw Error.cast
        }
        
        public static func encode(_ value: Foundation.NSNumber) throws -> IValue {
            return value
        }
        
    }

}
