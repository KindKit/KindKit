//
//  KindKit
//

import KindCore

public extension Coder {
    
    struct Identifier< CoderType, KindType : IIdentifierKind > {
    }
    
}

extension Coder.Identifier : IValueDecoder where CoderType : IValueDecoder, CoderType.JsonDecoded : Hashable {
    
    public typealias JsonDecoded = KindCore.Identifier< CoderType.JsonDecoded, KindType >
    
    public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
        return .init(try CoderType.decode(value, path: path))
    }
    
}

extension Coder.Identifier : IValueEncoder where CoderType : IValueEncoder, CoderType.JsonEncoded : Hashable {
    
    public typealias JsonEncoded = KindCore.Identifier< CoderType.JsonEncoded, KindType >
    
    public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
        return try CoderType.encode(value.id, path: path)
    }
    
}

extension Identifier : IDecoderAlias where RawType : IDecoderAlias, RawType.JsonDecoder.JsonDecoded : Hashable {
    
    public typealias JsonDecoder = Coder.Identifier< RawType.JsonDecoder, KindType >
    
}

extension Identifier : IEncoderAlias where RawType : IEncoderAlias, RawType.JsonEncoder.JsonEncoded : Hashable {
    
    public typealias JsonEncoder = Coder.Identifier< RawType.JsonEncoder, KindType >
    
}
