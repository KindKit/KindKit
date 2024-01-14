//
//  KindKit
//

import Foundation

public extension Coder {

    struct NSNumber : IValueCoder {
        
        public typealias JsonDecoded = Foundation.NSNumber
        public typealias JsonEncoded = Foundation.NSNumber
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            if let value = value as? Foundation.NSNumber {
                return value
            } else if let value = value as? Foundation.NSString {
                if let value = Foundation.NSNumber.kk_number(from: value) {
                    return value
                }
            }
            throw Error.Coding.cast(path)
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            return value
        }
        
    }

}
