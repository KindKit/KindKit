//
//  KindKit
//

import Foundation
import KindCodingOptions

extension Measurement : ValueDecoderTrait {
    
    public typealias JsonDecoded = Self
    public typealias JsonDecodeOptions = MeasurementCodingOptions
    
    public static func json(decode field: Field, in path: Path, with options: JsonDecodeOptions) throws -> JsonDecoded {
        let value = NSMeasurement(doubleValue: try Double.json(decode: field, in: path), unit: options.unit)
        return value as Measurement< UnitType >
    }
    
}

extension Measurement : ValueEncoderTrait {
    
    public typealias JsonEncoded = Self
    public typealias JsonEncodeOptions = MeasurementCodingOptions
    
    public static func json(encode value: JsonEncoded, in path: Path, with options: JsonEncodeOptions) throws -> Field? {
        let value = (value as NSMeasurement).converting(to: options.unit).value
        return try Double.json(encode: value, in: path)
    }
    
}
