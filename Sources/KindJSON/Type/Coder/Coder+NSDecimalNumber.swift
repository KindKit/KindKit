//
//  KindKit
//

import Foundation

public extension Coder {

    struct NSDecimalNumber : IValueCoder {
        
        public typealias JsonDecoded = Foundation.NSDecimalNumber
        public typealias JsonEncoded = Foundation.NSDecimalNumber
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            if let decimalNumber = value as? Foundation.NSDecimalNumber {
                return decimalNumber
            } else if let number = value as? Foundation.NSNumber {
                return .init(string: number.stringValue)
            } else if let string = value as? Foundation.NSString {
                if let decimalNumber = Foundation.NSDecimalNumber.kk_decimalNumber(from: string) {
                    return decimalNumber
                }
            }
            throw Error.Coding.cast(path)
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            return value
        }
        
    }

}
