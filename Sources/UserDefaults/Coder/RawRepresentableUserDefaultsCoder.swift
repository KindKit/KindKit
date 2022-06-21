//
//  KindKitUserDefaults
//

import Foundation
import KindKitCore

public struct RawRepresentableUserDefaultsDecoder< EnumType : RawRepresentable, DecoderType: IUserDefaultsValueDecoder > : IUserDefaultsValueDecoder where EnumType.RawValue == DecoderType.ValueType {
    
    public enum Error : Swift.Error {
        case cast
    }
    
    public static func decode(_ value: IUserDefaultsValue) throws -> EnumType {
        guard let rawValue = try? DecoderType.decode(value) else { throw Error.cast }
        guard let decoded = EnumType(rawValue: rawValue) else { throw Error.cast }
        return decoded
    }
    
}

public struct RawRepresentableUserDefaultsEncoder< EnumType : RawRepresentable, EncoderType: IUserDefaultsValueEncoder > : IUserDefaultsValueEncoder where EnumType.RawValue == EncoderType.ValueType {
    
    public static func encode(_ value: EnumType) throws -> IUserDefaultsValue {
        return try EncoderType.encode(value.rawValue)
    }
    
}
