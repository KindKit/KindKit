//
//  KindKit
//

import KindCore

extension ValueDecoderTrait where Self : RawRepresentable & RealEnumDecodeTrait, RawValue : ValueDecoderTrait, RawValue == RawValue.UserDefaultsDecoded {
    
    public static func userDefaults(decode field: Field, by key: String, with options: RawValue.UserDefaultsDecodeOptions) throws -> RealValue {
        let rawValue = try RawValue.userDefaults(decode: field, by: key, with: options)
        guard let value = Self.init(rawValue: rawValue) else {
            throw CodingError(by: key)
        }
        return value.realValue
    }

}
