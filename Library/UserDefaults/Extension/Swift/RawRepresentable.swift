//
//  KindKit
//

import KindCore

extension ValueDecoderTrait where Self : RawRepresentable, RawValue : ValueDecoderTrait, RawValue == RawValue.UserDefaultsDecoded {
    
    public static func userDefaults(decode field: Field, by key: String, with options: RawValue.UserDefaultsDecodeOptions) throws -> Self {
        let value = try RawValue.userDefaults(decode: field, by: key, with: options)
        guard let value = Self.init(rawValue: value) else {
            throw CodingError(by: key)
        }
        return value
    }

}

extension ValueEncoderTrait where Self : RawRepresentable, RawValue : ValueEncoderTrait, RawValue == RawValue.UserDefaultsEncoded {
    
    public static func userDefaults(encode value: Self, by key: String, with options: RawValue.UserDefaultsEncodeOptions) throws -> Field? {
        return try RawValue.userDefaults(encode: value.rawValue, by: key, with: options)
    }
    
}
