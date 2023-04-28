//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct NSDecimalNumber : IJsonValueCoder {
        
        public typealias JsonDecoded = Foundation.NSDecimalNumber
        public typealias JsonEncoded = Foundation.NSDecimalNumber
        
        public static func decode(_ value: IJsonValue, path: Json.Path) throws -> JsonDecoded {
            if let decimalNumber = value as? Foundation.NSDecimalNumber {
                return decimalNumber
            } else if let number = value as? Foundation.NSNumber {
                return .init(string: number.stringValue)
            } else if let string = value as? Foundation.NSString {
                if let decimalNumber = Foundation.NSDecimalNumber.kk_decimalNumber(from: string) {
                    return decimalNumber
                }
            }
            throw Json.Error.Coding.cast(path)
        }
        
        public static func encode(_ value: JsonEncoded, path: Json.Path) throws -> IJsonValue {
            return value
        }
        
    }

}
