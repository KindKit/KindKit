//
//  KindKit
//

import KindCore

extension Identifier : ValueDecoderTrait where Raw : ValueDecoderTrait, Raw == Raw.UserDefaultsDecoded {
    
    public typealias UserDefaultsDecoded = Self
    public typealias UserDefaultsDecodeOptions = Raw.UserDefaultsDecodeOptions
    
    public static func userDefaults(decode field: Field, by key: String, with options: UserDefaultsDecodeOptions) throws -> UserDefaultsDecoded {
        let value = try Raw.userDefaults(decode: field, by: key, with: options)
        return .init(value)
    }
    
}

extension Identifier : ValueEncoderTrait where Raw : ValueEncoderTrait, Raw == Raw.UserDefaultsEncoded {
    
    public typealias UserDefaultsEncoded = Self
    public typealias UserDefaultsEncodeOptions = Raw.UserDefaultsEncodeOptions
    
    public static func userDefaults(encode value: UserDefaultsEncoded, by key: String, with options: UserDefaultsEncodeOptions) throws -> Field? {
        return try Raw.userDefaults(encode: value.raw, by: key, with: options)
    }
    
}
