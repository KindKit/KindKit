//
//  KindKitUserDefaults
//

import Foundation
import KindKitCore

public struct EnumUserDefaultsDecoder< EnumType : IEnumDecodable, DecoderType: IUserDefaultsValueDecoder > : IUserDefaultsValueDecoder where EnumType.RawValue == DecoderType.ValueType {
    
    public enum Error : Swift.Error {
        case cast
    }
    
    public static func decode(_ value: IUserDefaultsValue) throws -> EnumType.RealValue {
        guard let rawValue = try? DecoderType.decode(value) else { throw Error.cast }
        guard let decoded = EnumType(rawValue: rawValue) else { throw Error.cast }
        return decoded.realValue
    }
    
}

public struct EnumUserDefaultsEncoder< EnumType : IEnumEncodable, EncoderType: IUserDefaultsValueEncoder > : IUserDefaultsValueEncoder where EnumType.RawValue == EncoderType.ValueType {
    
    public static func encode(_ value: EnumType.RealValue) throws -> IUserDefaultsValue {
        let encoded = EnumType(realValue: value)
        return try EncoderType.encode(encoded.rawValue)
    }
    
}
