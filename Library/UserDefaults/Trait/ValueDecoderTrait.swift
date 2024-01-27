//
//  KindKit
//

import KindCodingOptions

public protocol ValueDecoderTrait {
    
    associatedtype UserDefaultsDecoded
    associatedtype UserDefaultsDecodeOptions : CodingOptions
    
    static func userDefaults(decode field: Field, by key: String, with options: UserDefaultsDecodeOptions) throws -> UserDefaultsDecoded
    
    static func userDefaults(decode error: AccessError, with options: UserDefaultsDecodeOptions) throws -> UserDefaultsDecoded
    
}

public extension ValueDecoderTrait {
    
    @inlinable
    static func userDefaults(decode error: AccessError, with options: UserDefaultsDecodeOptions) throws -> UserDefaultsDecoded {
        throw error
    }
    
}

public extension ValueDecoderTrait where UserDefaultsDecodeOptions : DefaultCodingOptions {
    
    @inlinable
    static func userDefaults(decode field: Field, by key: String) throws -> UserDefaultsDecoded {
        return try self.userDefaults(decode: field, by: key, with: .default)
    }
    
    @inlinable
    static func userDefaults(decode error: AccessError) throws -> UserDefaultsDecoded {
        return try self.userDefaults(decode: error, with: .default)
    }
    
}
