//
//  KindKit
//

import KindCore

public extension Coder {
    
    struct Identifier< CoderType, KindType : IIdentifierKind > {
    }
    
}

extension Coder.Identifier : IValueDecoder where CoderType : IValueDecoder, CoderType.UserDefaultsDecoded : Hashable {
    
    public typealias UserDefaultsDecoded = KindCore.Identifier< CoderType.UserDefaultsDecoded, KindType >
    
    public static func decode(_ value: IValue) throws -> UserDefaultsDecoded {
        return .init(try CoderType.decode(value))
    }
    
}

extension Coder.Identifier : IValueEncoder where CoderType : IValueEncoder, CoderType.UserDefaultsEncoded : Hashable {
    
    public typealias UserDefaultsEncoded = KindCore.Identifier< CoderType.UserDefaultsEncoded, KindType >
    
    public static func encode(_ value: UserDefaultsEncoded) throws -> IValue {
        return try CoderType.encode(value.id)
    }
    
}

extension Identifier : IDecoderAlias where RawType : IDecoderAlias, RawType.UserDefaultsDecoder.UserDefaultsDecoded : Hashable {
    
    public typealias UserDefaultsDecoder = Coder.Identifier< RawType.UserDefaultsDecoder, KindType >
    
}

extension Identifier : IEncoderAlias where RawType : IEncoderAlias, RawType.UserDefaultsEncoder.UserDefaultsEncoded : Hashable {
    
    public typealias UserDefaultsEncoder = Coder.Identifier< RawType.UserDefaultsEncoder, KindType >
    
}
