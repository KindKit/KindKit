//
//  KindKit
//

import Foundation

extension Decimal : ValueDecoderTrait {
    
    public typealias UserDefaultsDecoded = Self
    public typealias UserDefaultsDecodeOptions = EmptyCodingOptions
    
    public static func userDefaults(decode field: Field, by key: String, with options: UserDefaultsDecodeOptions) throws -> UserDefaultsDecoded {
        let value = try NSDecimalNumberCoder.userDefaults(decode: field, by: key, with: options)
        return value as Decimal
    }
    
}

extension Decimal : ValueEncoderTrait {
    
    public typealias UserDefaultsEncoded = Self
    public typealias UserDefaultsEncodeOptions = EmptyCodingOptions
    
    public static func userDefaults(encode value: UserDefaultsEncoded, by key: String, with options: UserDefaultsEncodeOptions) throws -> Field? {
        let value = NSDecimalNumber(decimal: value)
        return try NSDecimalNumberCoder.userDefaults(encode: value, by: key, with: options)
    }
    
}
