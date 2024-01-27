//
//  KindKit
//

import Foundation
import KindCodingOptions

extension Measurement : ValueDecoderTrait {
    
    public typealias KeychainDecoded = Self
    public typealias KeychainDecodeOptions = MeasurementCodingOptions
    
    public static func keychain(decode field: Data, in key: String, with options: KeychainDecodeOptions) throws -> KeychainDecoded {
        let value = try Double.keychain(decode: field, in: key)
        return NSMeasurement(doubleValue: value, unit: options.unit) as Measurement< UnitType >
    }
    
}

extension Measurement : ValueEncoderTrait {
    
    public typealias KeychainEncoded = Self
    public typealias KeychainEncodeOptions = MeasurementCodingOptions
    
    public static func keychain(encode value: KeychainEncoded, in key: String, with options: KeychainEncodeOptions) throws -> Data? {
        let value = (value as NSMeasurement).converting(to: options.unit).value
        return try Double.keychain(encode: value, in: key)
    }
    
}
