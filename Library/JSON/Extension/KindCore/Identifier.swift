//
//  KindKit
//

import KindCore

extension Identifier : ValueDecoderTrait where Raw : ValueDecoderTrait, Raw == Raw.JsonDecoded {
    
    public typealias JsonDecoded = Self
    public typealias JsonDecodeOptions = Raw.JsonDecodeOptions
    
    public static func json(decode field: Field, in path: Path, with options: JsonDecodeOptions) throws -> JsonDecoded {
        let value = try Raw.json(decode: field, in: path, with: options)
        return .init(value)
    }
    
}

extension Identifier : ValueEncoderTrait where Raw : ValueEncoderTrait, Raw == Raw.JsonEncoded {
    
    public typealias JsonEncoded = Self
    public typealias JsonEncodeOptions = Raw.JsonEncodeOptions
    
    public static func json(encode value: JsonEncoded, in path: Path, with options: JsonEncodeOptions) throws -> Field? {
        return try Raw.json(encode: value.raw, in: path, with: options)
    }
    
}
