//
//  KindKit
//

import KindCodingOptions

public protocol ValueDecoderTrait {
    
    associatedtype JsonDecoded
    associatedtype JsonDecodeOptions : CodingOptions
    
    static func json(decode field: Field, in path: Path, with options: JsonDecodeOptions) throws -> JsonDecoded
    
    static func json(decode error: AccessError, with options: JsonDecodeOptions) throws -> JsonDecoded
    
}

public extension ValueDecoderTrait {
    
    @inlinable
    static func json(decode error: AccessError, with options: JsonDecodeOptions) throws -> JsonDecoded {
        throw error
    }
    
}

public extension ValueDecoderTrait where JsonDecodeOptions : DefaultCodingOptions {
    
    @inlinable
    static func json(decode field: Field, in path: Path) throws -> JsonDecoded {
        return try self.json(decode: field, in: path, with: .default)
    }
    
    @inlinable
    static func json(decode error: AccessError) throws -> JsonDecoded {
        return try self.json(decode: error, with: .default)
    }
    
}
