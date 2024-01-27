//
//  KindKit
//

import Foundation
import KindCore

public extension Coder {
    
    struct Identifier< CoderType, KindType : IIdentifierKind > {
    }
    
}

extension Coder.Identifier : IValueDecoder where CoderType : IValueDecoder, CoderType.KeychainDecoded : Hashable {
    
    public typealias KeychainDecoded = KindCore.Identifier< CoderType.KeychainDecoded, KindType >
    
    public static func decode(_ value: Data) throws -> KeychainDecoded {
        return .init(try CoderType.decode(value))
    }
    
}

extension Coder.Identifier : IValueEncoder where CoderType : IValueEncoder, CoderType.KeychainEncoded : Hashable {
    
    public typealias KeychainEncoded = KindCore.Identifier< CoderType.KeychainEncoded, KindType >
    
    public static func encode(_ value: KeychainEncoded) throws -> Data {
        return try CoderType.encode(value.id)
    }
    
}

extension Identifier : IDecoderAlias where RawType : IDecoderAlias, RawType.KeychainDecoder.KeychainDecoded : Hashable {
    
    public typealias KeychainDecoder = Coder.Identifier< RawType.KeychainDecoder, KindType >
    
}

extension Identifier : IEncoderAlias where RawType : IEncoderAlias, RawType.KeychainEncoder.KeychainEncoded : Hashable {
    
    public typealias KeychainEncoder = Coder.Identifier< RawType.KeychainEncoder, KindType >
    
}
