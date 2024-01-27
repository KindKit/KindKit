//
//  KindKit
//

import Foundation
import KindCore

extension ValueDecoderTrait where Self : RawRepresentable & RealEnumDecodeTrait, RawValue : ValueDecoderTrait, RawValue == RawValue.KeychainDecoded {
    
    public static func keychain(decode field: Data, in path: String, with options: RawValue.KeychainDecodeOptions) throws -> RealValue {
        let rawValue = try RawValue.keychain(decode: field, in: path, with: options)
        guard let value = Self.init(rawValue: rawValue) else {
            throw CodingError(in: path)
        }
        return value.realValue
    }

}
