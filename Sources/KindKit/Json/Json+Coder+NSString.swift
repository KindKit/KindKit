//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct NSString : IJsonValueCoder {
        
        public typealias JsonDecoded = Foundation.NSString
        public typealias JsonEncoded = Foundation.NSString
        
        public static func decode(_ value: IJsonValue, path: Json.Path) throws -> JsonDecoded {
            if let value = value as? Foundation.NSString {
                return value
            } else if let value = value as? Foundation.NSNumber {
                return value.stringValue as Foundation.NSString
            } else if let value = value as? Foundation.NSDecimalNumber {
                return value.stringValue as Foundation.NSString
            }
            throw Json.Error.Coding.cast(path)
        }
        
        public static func encode(_ value: JsonEncoded, path: Json.Path) throws -> IJsonValue {
            return value
        }
        
    }

}
