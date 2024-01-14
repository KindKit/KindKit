//
//  KindKit
//

import KindCore

public extension Coder {
    
    struct Identifier< Coder, Kind : IIdentifierKind > {
    }
    
}

extension Coder.Identifier : IValueDecoder where Coder : IValueDecoder {
    
    public static func decode(_ value: IValue) throws -> KindCore.Identifier< Coder.UserDefaultsDecoded, Kind > {
        return Identifier(try Coder.decode(value))
    }
    
}

extension Coder.Identifier : IValueEncoder where Coder : IValueEncoder {
    
    public static func encode(_ value: KindCore.Identifier< Coder.UserDefaultsEncoded, Kind >) throws -> IValue {
        return try Coder.encode(value.raw)
    }
    
}

extension Identifier : IDecoderAlias where Raw : IDecoderAlias {
    
    public typealias UserDefaultsDecoder = Coder.Identifier< Raw.UserDefaultsDecoder, Kind >
    
}

extension Identifier : IEncoderAlias where Raw : IEncoderAlias {
    
    public typealias UserDefaultsEncoder = Coder.Identifier< Raw.UserDefaultsEncoder, Kind >
    
}
