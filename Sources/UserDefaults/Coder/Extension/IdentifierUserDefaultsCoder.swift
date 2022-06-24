//
//  KindKitUserDefaults
//

import Foundation
import KindKitCore

public struct IdentifierUserDefaultsDecoder< RawDecoder : IUserDefaultsValueDecoder, Kind : IIdentifierKind > : IUserDefaultsValueDecoder {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> Identifier< RawDecoder.Value, Kind > {
        return Identifier(try RawDecoder.decode(value))
    }
    
}

public struct IdentifierUserDefaultsEncoder< RawEncoder : IUserDefaultsValueEncoder, Kind : IIdentifierKind > : IUserDefaultsValueEncoder {
    
    public static func encode(_ value: Identifier< RawEncoder.Value, Kind >) throws -> IUserDefaultsValue {
        return try RawEncoder.encode(value.raw)
    }
    
}

extension Identifier : IUserDefaultsDecoderAlias where Raw : IUserDefaultsDecoderAlias {
    
    public typealias UserDefaultsDecoder = IdentifierUserDefaultsDecoder< Raw.UserDefaultsDecoder, Kind >
    
}

extension Identifier : IUserDefaultsEncoderAlias where Raw : IUserDefaultsEncoderAlias {
    
    public typealias UserDefaultsEncoder = IdentifierUserDefaultsEncoder< Raw.UserDefaultsEncoder, Kind >
    
}
