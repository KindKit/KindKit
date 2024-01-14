//
//  KindKit
//

import Foundation
import KindCore

public extension Coder {
    
    struct Enum< EnumCoder, RawCoder > {
    }
    
}

extension Coder.Enum : IValueDecoder where EnumCoder : IEnumDecodable, RawCoder : IValueDecoder, EnumCoder.RawValue == RawCoder.KeychainDecoded {
    
    public static func decode(_ value: Data) throws -> EnumCoder.RealValue {
        guard let rawValue = try? RawCoder.decode(value) else {
            throw Error.cast
        }
        guard let decoded = EnumCoder(rawValue: rawValue) else {
            throw Error.cast
        }
        return decoded.realValue
    }

}

extension Coder.Enum : IValueEncoder where EnumCoder : IEnumEncodable, RawCoder : IValueEncoder, EnumCoder.RawValue == RawCoder.KeychainEncoded {
    
    public static func encode(_ value: EnumCoder.RealValue) throws -> Data {
        let encoded = EnumCoder(realValue: value)
        return try RawCoder.encode(encoded.rawValue)
    }
    
}

extension IDecoderAlias where Self : IEnumDecodable, RawValue : IDecoderAlias, RawValue == RawValue.KeychainDecoder.KeychainDecoded {
    
    public typealias KeychainDecoder = Coder.Enum< Self, Self.RawValue.KeychainDecoder >
    
}

extension IEncoderAlias where Self : IEnumEncodable, RawValue : IEncoderAlias, RawValue == RawValue.KeychainEncoder.KeychainEncoded {
    
    public typealias KeychainEncoder = Coder.Enum< Self, Self.RawValue.KeychainEncoder >
    
}
