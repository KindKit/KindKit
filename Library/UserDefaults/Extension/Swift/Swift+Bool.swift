//
//  KindKit
//

import Foundation
import KindCodingOptions

extension Bool : ValueDecoderTrait {
    
    public typealias UserDefaultsDecoded = Bool
    public typealias UserDefaultsDecodeOptions = EmptyCodingOptions
    
    public static func userDefaults(decode field: Field, by key: String, with options: UserDefaultsDecodeOptions) throws -> UserDefaultsDecoded {
        if let number = field as? NSNumber {
            return number.boolValue
        } else if let string = field as? NSString {
            switch string.lowercased {
            case "true", "yes", "on": return true
            case "false", "no", "off": return false
            default: break
            }
        }
        throw CodingError(by: key)
    }
    
}

extension Bool : ValueEncoderTrait {
    
    public typealias UserDefaultsEncoded = Bool
    public typealias UserDefaultsEncodeOptions = EmptyCodingOptions
    
    public static func userDefaults(encode value: UserDefaultsEncoded, by key: String, with options: UserDefaultsEncodeOptions) throws -> Field? {
        return NSNumber(value: value)
    }
    
}

