//
//  KindKit
//

import Foundation

public extension Json.Coder {
    
    struct Identifier< Coder, Kind : IIdentifierKind > {
    }
    
}

extension Json.Coder.Identifier : IJsonValueDecoder where Coder : IJsonValueDecoder {
    
    public typealias JsonDecoded = KindKit.Identifier< Coder.JsonDecoded, Kind >
    
    public static func decode(
        _ value: IJsonValue,
        path: Json.Path
    ) throws -> JsonDecoded {
        return Identifier(try Coder.decode(value, path: path))
    }
    
}

extension Json.Coder.Identifier : IJsonValueEncoder where Coder : IJsonValueEncoder {
    
    public typealias JsonEncoded = KindKit.Identifier< Coder.JsonEncoded, Kind >
    
    public static func encode(
        _ value: JsonEncoded,
        path: Json.Path
    ) throws -> IJsonValue {
        return try Coder.encode(value.raw, path: path)
    }
    
}

extension Identifier : IJsonDecoderAlias where Raw : IJsonDecoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Identifier< Raw.JsonDecoder, Kind >
    
}

extension Identifier : IJsonEncoderAlias where Raw : IJsonEncoderAlias {
    
    public typealias JsonEncoder = Json.Coder.Identifier< Raw.JsonEncoder, Kind >
    
}
