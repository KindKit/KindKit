//
//  KindKit
//

import Foundation
import KindCore
import KindCodingOptions

extension Optional : ValueDecoderTrait where Wrapped : ValueDecoderTrait, Wrapped == Wrapped.JsonDecoded {
    
    public typealias JsonDecoded = Self
    public typealias JsonDecodeOptions = OptionalDecodeOptions< Wrapped.JsonDecodeOptions, Wrapped >
    
    public static func json(decode field: Field, in path: Path, with options: JsonDecodeOptions) throws -> JsonDecoded {
        guard let value = try? Wrapped.json(decode: field, in: path, with: options.wrapped) else {
            return options.default
        }
        return .some(value)
    }
    
    public static func json(decode error: AccessError, with options: JsonDecodeOptions) throws -> JsonDecoded {
        return options.default
    }
    
}

extension Optional : ValueEncoderTrait where Wrapped : ValueEncoderTrait, Wrapped == Wrapped.JsonEncoded {
    
    public typealias JsonEncoded = Self
    public typealias JsonEncodeOptions = OptionalEncodeOptions< Wrapped.JsonEncodeOptions >
    
    public static func json(encode value: JsonEncoded, in path: Path, with options: JsonEncodeOptions) throws -> Field? {
        switch value {
        case .some(let value):
            return try Wrapped.json(encode: value, in: path, with: options.wrapped)
        case .none:
            switch options.options {
            case .skippable: return nil
            case .nullable: return NSNull()
            }
        }
    }
    
}
