//
//  KindKit
//

import Foundation

public extension Coder {

    struct NSString : IValueCoder {
        
        public typealias JsonDecoded = Foundation.NSString
        public typealias JsonEncoded = Foundation.NSString
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            if let value = value as? Foundation.NSString {
                return value
            } else if let value = value as? Foundation.NSNumber {
                return value.stringValue as Foundation.NSString
            } else if let value = value as? Foundation.NSDecimalNumber {
                return value.stringValue as Foundation.NSString
            }
            throw Error.Coding.cast(path)
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            return value
        }
        
    }

}
