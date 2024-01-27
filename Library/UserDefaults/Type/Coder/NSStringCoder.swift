//
//  KindKit
//

import Foundation
import KindCodingOptions

public struct NSStringCoder : ValueCoderTrait {
    
    public typealias UserDefaultsDecoded = NSString
    public typealias UserDefaultsDecodeOptions = EmptyCodingOptions
    
    public typealias UserDefaultsEncoded = NSString
    public typealias UserDefaultsEncodeOptions = EmptyCodingOptions
    
    public static func userDefaults(decode field: Field, by key: String, with options: UserDefaultsDecodeOptions) throws -> UserDefaultsDecoded {
        if let value = field as? NSString {
            return value
        } else if let value = field as? NSDecimalNumber {
            return value.stringValue as NSString
        } else if let value = field as? NSNumber {
            return value.stringValue as NSString
        }
        throw CodingError(by: key)
    }
    
    public static func userDefaults(encode value: UserDefaultsEncoded, by key: String, with options: UserDefaultsEncodeOptions) throws -> Field? {
        return value
    }
    
}
