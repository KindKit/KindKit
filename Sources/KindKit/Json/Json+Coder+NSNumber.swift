//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct NSNumber : IJsonValueCoder {
        
        public typealias JsonDecoded = Foundation.NSNumber
        public typealias JsonEncoded = Foundation.NSNumber
        
        public static func decode(_ value: IJsonValue, path: Json.Path) throws -> JsonDecoded {
            if let value = value as? Foundation.NSNumber {
                return value
            } else if let value = value as? Foundation.NSString {
                if let value = Foundation.NSNumber.kk_number(from: value) {
                    return value
                }
            }
            throw Json.Error.Coding.cast(path)
        }
        
        public static func encode(_ value: JsonEncoded, path: Json.Path) throws -> IJsonValue {
            return value
        }
        
    }

}
