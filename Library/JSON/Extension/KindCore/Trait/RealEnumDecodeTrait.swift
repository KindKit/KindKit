//
//  KindKit
//

import KindCore

extension ValueDecoderTrait where Self : RawRepresentable & RealEnumDecodeTrait, RawValue : ValueDecoderTrait, RawValue == RawValue.JsonDecoded {
    
    public static func json(decode field: Field, in path: Path, with options: RawValue.JsonDecodeOptions) throws -> RealValue {
        let rawValue = try RawValue.json(decode: field, in: path, with: options)
        guard let value = Self.init(rawValue: rawValue) else {
            throw CodingError(in: path)
        }
        return value.realValue
    }

}
