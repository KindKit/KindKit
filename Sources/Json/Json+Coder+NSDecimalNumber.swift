//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct NSDecimalNumber : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Foundation.NSDecimalNumber {
            if let decimalNumber = value as? Foundation.NSDecimalNumber {
                return decimalNumber
            } else if let number = value as? Foundation.NSNumber {
                return .init(string: number.stringValue)
            } else if let string = value as? Foundation.NSString, let decimalNumber = Foundation.NSDecimalNumber.kk_decimalNumber(from: string) {
                return decimalNumber
            }
            throw Json.Error.cast
        }
        
        public static func encode(_ value: Foundation.NSDecimalNumber) throws -> IJsonValue {
            return value
        }
        
    }

}
