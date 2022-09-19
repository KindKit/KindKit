//
//  KindKit
//

import Foundation

public extension Json.Coder {
    
    struct Identifier< Coder, Kind : IIdentifierKind > {
    }
    
}

extension Json.Coder.Identifier : IJsonValueDecoder where Coder : IJsonValueDecoder {
    
    public static func decode(_ value: IJsonValue) throws -> KindKit.Identifier< Coder.JsonDecoded, Kind > {
        return Identifier(try Coder.decode(value))
    }
    
}

extension Json.Coder.Identifier : IJsonValueEncoder where Coder : IJsonValueEncoder {
    
    public static func encode(_ value: KindKit.Identifier< Coder.JsonEncoded, Kind >) throws -> IJsonValue {
        return try Coder.encode(value.raw)
    }
    
}

extension Identifier : IJsonDecoderAlias where Raw : IJsonDecoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Identifier< Raw.JsonDecoder, Kind >
    
}

extension Identifier : IJsonEncoderAlias where Raw : IJsonEncoderAlias {
    
    public typealias JsonEncoder = Json.Coder.Identifier< Raw.JsonEncoder, Kind >
    
}
