//
//  KindKit
//

import Foundation
import KindCore

extension ValueEncoderTrait where Self : RawRepresentable & RealEnumEncodeTrait, RawValue : ValueEncoderTrait, RawValue == RawValue.KeychainEncoded {
    
    public static func keychain(encode value: RealValue, in key: String, with options: RawValue.KeychainEncodeOptions) throws -> Data? {
        let value = Self.init(realValue: value)
        return try RawValue.keychain(encode: value.rawValue, in: key, with: options)
    }
    
}
