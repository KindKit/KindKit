//
//  KindKit
//

import Foundation
import KindCodingOptions

extension Measurement : ValueDecoderTrait {
    
    public typealias UserDefaultsDecoded = Self
    public typealias UserDefaultsDecodeOptions = MeasurementCodingOptions
    
    public static func userDefaults(decode field: Field, by key: String, with options: UserDefaultsDecodeOptions) throws -> UserDefaultsDecoded {
        let value = NSMeasurement(doubleValue: try Double.userDefaults(decode: field, by: key), unit: options.unit)
        return value as Measurement< UnitType >
    }
    
}

extension Measurement : ValueEncoderTrait {
    
    public typealias UserDefaultsEncoded = Self
    public typealias UserDefaultsEncodeOptions = MeasurementCodingOptions
    
    public static func userDefaults(encode value: UserDefaultsEncoded, by key: String, with options: UserDefaultsEncodeOptions) throws -> Field? {
        let value = (value as NSMeasurement).converting(to: options.unit).value
        return try Double.userDefaults(encode: value, by: key)
    }
    
}
