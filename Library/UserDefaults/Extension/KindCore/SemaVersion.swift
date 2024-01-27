//
//  KindKit
//

import KindCore

extension SemaVersion : ValueDecoderTrait {
    
    public typealias UserDefaultsDecoded = SemaVersion
    public typealias UserDefaultsDecodeOptions = String.UserDefaultsDecodeOptions
    
    public static func userDefaults(decode field: Field, by key: String, with options: UserDefaultsDecodeOptions) throws -> UserDefaultsDecoded {
        let value = try String.userDefaults(decode: field, by: key, with: options)
        guard let value = SemaVersion(value) else {
            throw CodingError(by: key)
        }
        return value
    }
    
}

extension SemaVersion : ValueEncoderTrait {
    
    public typealias UserDefaultsEncoded = SemaVersion
    public typealias UserDefaultsEncodeOptions = SemaVersion.MakeOptions
    
    public static func userDefaults(encode value: UserDefaultsEncoded, by key: String, with options: UserDefaultsEncodeOptions) throws -> Field? {
        return try String.userDefaults(encode: value.make(options: options), by: key)
    }
    
}
