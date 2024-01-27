//
//  KindKit
//

import KindCodingOptions

public protocol ValueEncoderTrait {
    
    associatedtype UserDefaultsEncoded
    associatedtype UserDefaultsEncodeOptions : CodingOptions

    static func userDefaults(encode value: UserDefaultsEncoded, by key: String, with options: UserDefaultsEncodeOptions) throws -> Field?
    
}

public extension ValueEncoderTrait where UserDefaultsEncodeOptions : DefaultCodingOptions {
    
    @inlinable
    static func userDefaults(encode value: UserDefaultsEncoded, by key: String) throws -> Field? {
        return try self.userDefaults(encode: value, by: key, with: .default)
    }
    
}
