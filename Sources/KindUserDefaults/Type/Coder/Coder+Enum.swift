//
//  KindKit
//

import Foundation

public extension Coder {
    
    struct Enum< EnumCoder, RawCoder > {
    }
    
}

extension Coder.Enum : IValueDecoder where EnumCoder : IEnumDecodable, RawCoder : IValueDecoder, EnumCoder.RawValue == RawCoder.UserDefaultsDecoded {
    
    public static func decode(_ value: IValue) throws -> EnumCoder.RealValue {
        guard let rawValue = try? RawCoder.decode(value) else {
            throw Error.cast
        }
        guard let decoded = EnumCoder(rawValue: rawValue) else {
            throw Error.cast
        }
        return decoded.realValue
    }

}

extension Coder.Enum : IValueEncoder where EnumCoder : IEnumEncodable, RawCoder : IValueEncoder, EnumCoder.RawValue == RawCoder.UserDefaultsEncoded {
    
    public static func encode(_ value: EnumCoder.RealValue) throws -> IValue {
        let encoded = EnumCoder(realValue: value)
        return try RawCoder.encode(encoded.rawValue)
    }
    
}

extension IDecoderAlias where Self : IEnumDecodable, RawValue : IDecoderAlias, RawValue == RawValue.UserDefaultsDecoder.UserDefaultsDecoded {
    
    public typealias UserDefaultsDecoder = Coder.Enum< Self, Self.RawValue.UserDefaultsDecoder >
    
}

extension IEncoderAlias where Self : IEnumEncodable, RawValue : IEncoderAlias, RawValue == RawValue.UserDefaultsEncoder.UserDefaultsEncoded {
    
    public typealias UserDefaultsEncoder = Coder.Enum< Self, Self.RawValue.UserDefaultsEncoder >
    
}
