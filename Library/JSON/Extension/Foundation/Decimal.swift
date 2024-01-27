//
//  KindKit
//

import Foundation

extension Decimal : ValueDecoderTrait {
    
    public typealias JsonDecoded = Self
    public typealias JsonDecodeOptions = EmptyCodingOptions
    
    public static func json(decode field: Field, in path: Path, with options: JsonDecodeOptions) throws -> JsonDecoded {
        let value = try NSDecimalNumberCoder.json(decode: field, in: path, with: options)
        return value as Decimal
    }
    
}

extension Decimal : ValueEncoderTrait {
    
    public typealias JsonEncoded = Self
    public typealias JsonEncodeOptions = EmptyCodingOptions
    
    public static func json(encode value: JsonEncoded, in path: Path, with options: JsonEncodeOptions) throws -> Field? {
        let value = NSDecimalNumber(decimal: value)
        return try NSDecimalNumberCoder.json(encode: value, in: path, with: options)
    }
    
}
