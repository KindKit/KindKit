//
//  KindKit
//

import KindCore

extension SemaVersion : ValueDecoderTrait {
    
    public typealias JsonDecoded = SemaVersion
    public typealias JsonDecodeOptions = String.JsonDecodeOptions
    
    public static func json(decode field: Field, in path: Path, with options: JsonDecodeOptions) throws -> JsonDecoded {
        let value = try String.json(decode: field, in: path, with: options)
        guard let value = SemaVersion(value) else {
            throw CodingError(in: path)
        }
        return value
    }
    
}

extension SemaVersion : ValueEncoderTrait {
    
    public typealias JsonEncoded = SemaVersion
    public typealias JsonEncodeOptions = SemaVersion.MakeOptions
    
    public static func json(encode value: JsonEncoded, in path: Path, with options: JsonEncodeOptions) throws -> Field? {
        return try String.json(encode: value.make(options: options), in: path)
    }
    
}
