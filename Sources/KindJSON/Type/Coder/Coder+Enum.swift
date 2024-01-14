//
//  KindKit
//

import Foundation
import KindCore

public extension Coder {
    
    struct Enum< EnumCoder, RawCoder > {
    }
    
}

extension Coder.Enum : IValueDecoder where EnumCoder : IEnumDecodable, RawCoder : IValueDecoder, EnumCoder.RawValue == RawCoder.JsonDecoded {
    
    public typealias JsonDecoded = EnumCoder.RealValue
    
    public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
        let rawValue = try RawCoder.decode(value, path: path)
        guard let decoded = EnumCoder(rawValue: rawValue) else {
            throw Error.Coding.cast(path)
        }
        return decoded.realValue
    }

}

extension Coder.Enum : IValueEncoder where EnumCoder : IEnumEncodable, RawCoder : IValueEncoder, EnumCoder.RawValue == RawCoder.JsonEncoded {
    
    public typealias JsonEncoded = EnumCoder.RealValue
    
    public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
        let encoded = EnumCoder(realValue: value)
        return try RawCoder.encode(encoded.rawValue, path: path)
    }
    
}

extension IDecoderAlias where Self : IEnumDecodable, RawValue : IDecoderAlias, RawValue == RawValue.JsonDecoder.JsonDecoded {
    
    public typealias JsonDecoder = Coder.Enum< Self, Self.RawValue.JsonDecoder >
    
}

extension IEncoderAlias where Self : IEnumEncodable, RawValue : IEncoderAlias, RawValue == RawValue.JsonEncoder.JsonEncoded {
    
    public typealias JsonEncoder = Coder.Enum< Self, Self.RawValue.JsonEncoder >
    
}
