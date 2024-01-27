//
//  KindKit
//

import KindCore

extension ValueEncoderTrait where Self : RawRepresentable & RealEnumEncodeTrait, RawValue : ValueEncoderTrait, RawValue == RawValue.JsonEncoded {
    
    public static func json(encode value: RealValue, in path: Path, with options: RawValue.JsonEncodeOptions) throws -> Field? {
        let value = Self.init(realValue: value)
        return try RawValue.json(encode: value.rawValue, in: path, with: options)
    }
    
}
