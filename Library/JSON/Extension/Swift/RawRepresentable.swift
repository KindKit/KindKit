//
//  KindKit
//

import KindCore

extension ValueDecoderTrait where Self : RawRepresentable, RawValue : ValueDecoderTrait, RawValue == RawValue.JsonDecoded {
    
    public static func json(decode field: Field, in path: Path, with options: RawValue.JsonDecodeOptions) throws -> Self {
        let value = try RawValue.json(decode: field, in: path, with: options)
        guard let value = Self.init(rawValue: value) else {
            throw CodingError(in: path)
        }
        return value
    }

}

extension ValueEncoderTrait where Self : RawRepresentable, RawValue : ValueEncoderTrait, RawValue == RawValue.JsonEncoded {
    
    public static func json(encode value: Self, in path: Path, with options: RawValue.JsonEncodeOptions) throws -> Field? {
        return try RawValue.json(encode: value.rawValue, in: path, with: options)
    }
    
}
