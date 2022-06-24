//
//  KindKitJson
//

import Foundation
import KindKitCore

public struct IdentifierJsonDecoder< RawDecoder : IJsonValueDecoder, Kind : IIdentifierKind > : IJsonValueDecoder {
    
    public static func decode(_ value: IJsonValue) throws -> Identifier< RawDecoder.Value, Kind > {
        return Identifier(try RawDecoder.decode(value))
    }
    
}

public struct IdentifierJsonEncoder< RawEncoder : IJsonValueEncoder, Kind : IIdentifierKind > : IJsonValueEncoder {
    
    public static func encode(_ value: Identifier< RawEncoder.Value, Kind >) throws -> IJsonValue {
        return try RawEncoder.encode(value.raw)
    }
    
}

extension Identifier : IJsonDecoderAlias where Raw : IJsonDecoderAlias {
    
    public typealias JsonDecoder = IdentifierJsonDecoder< Raw.JsonDecoder, Kind >
    
}

extension Identifier : IJsonEncoderAlias where Raw : IJsonEncoderAlias {
    
    public typealias JsonEncoder = IdentifierJsonEncoder< Raw.JsonEncoder, Kind >
    
}
