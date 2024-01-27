//
//  KindKit
//

import KindCore

extension ValueEncoderTrait where Self : RawRepresentable & RealEnumEncodeTrait, RawValue : ValueEncoderTrait, RawValue == RawValue.UserDefaultsEncoded {
    
    public static func userDefaults(encode value: RealValue, by key: String, with options: RawValue.UserDefaultsEncodeOptions) throws -> Field? {
        let value = Self.init(realValue: value)
        return try RawValue.userDefaults(encode: value.rawValue, by: key, with: options)
    }
    
}
