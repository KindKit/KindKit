//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct NSNumber : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Foundation.NSNumber {
            if let number = value as? Foundation.NSNumber {
                return number
            } else if let string = value as? Foundation.NSString, let number = Foundation.NSNumber.kk_number(from: string) {
                return number
            }
            throw Json.Error.cast
        }
        
        public static func encode(_ value: Foundation.NSNumber) throws -> IJsonValue {
            return value
        }
        
    }

}
