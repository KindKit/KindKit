//
//  KindKit
//

import Foundation
import KindCodingOptions

public struct NSNumberCoder : ValueCoderTrait {
    
    public typealias UserDefaultsDecoded = NSNumber
    public typealias UserDefaultsDecodeOptions = EmptyCodingOptions
    
    public typealias UserDefaultsEncoded = NSNumber
    public typealias UserDefaultsEncodeOptions = EmptyCodingOptions
    
    public static func userDefaults(decode field: Field, by key: String, with options: UserDefaultsDecodeOptions) throws -> UserDefaultsDecoded {
        if let value = field as? NSNumber {
            return value
        } else if let value = field as? NSString {
            if let value = NSNumber.kk_number(from: value) {
                return value
            }
        }
        throw CodingError(by: key)
    }
    
    public static func userDefaults(encode value: UserDefaultsEncoded, by key: String, with options: UserDefaultsEncodeOptions) throws -> Field? {
        return value
    }
    
}
