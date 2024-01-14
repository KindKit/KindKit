//
//  KindKit
//

import KindCore

public extension Coder {
    
    struct Identifier< Coder, Kind : IIdentifierKind > {
    }
    
}

extension Coder.Identifier : IValueDecoder where Coder : IValueDecoder {
    
    public typealias JsonDecoded = KindCore.Identifier< Coder.JsonDecoded, Kind >
    
    public static func decode(
        _ value: IValue,
        path: Path
    ) throws -> JsonDecoded {
        return Identifier(try Coder.decode(value, path: path))
    }
    
}

extension Coder.Identifier : IValueEncoder where Coder : IValueEncoder {
    
    public typealias JsonEncoded = KindCore.Identifier< Coder.JsonEncoded, Kind >
    
    public static func encode(
        _ value: JsonEncoded,
        path: Path
    ) throws -> IValue {
        return try Coder.encode(value.raw, path: path)
    }
    
}

extension Identifier : IDecoderAlias where Raw : IDecoderAlias {
    
    public typealias JsonDecoder = Coder.Identifier< Raw.JsonDecoder, Kind >
    
}

extension Identifier : IEncoderAlias where Raw : IEncoderAlias {
    
    public typealias JsonEncoder = Coder.Identifier< Raw.JsonEncoder, Kind >
    
}
