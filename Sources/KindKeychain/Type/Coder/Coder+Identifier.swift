//
//  KindKit
//

import Foundation
import KindCore

public extension Coder {
    
    struct Identifier< Coder, Kind : IIdentifierKind > {
    }
    
}

extension Coder.Identifier : IValueDecoder where Coder : IValueDecoder {
    
    public static func decode(_ value: Data) throws -> KindCore.Identifier< Coder.KeychainDecoded, Kind > {
        return Identifier(try Coder.decode(value))
    }
    
}

extension Coder.Identifier : IValueEncoder where Coder : IValueEncoder {
    
    public static func encode(_ value: KindCore.Identifier< Coder.KeychainEncoded, Kind >) throws -> Data {
        return try Coder.encode(value.raw)
    }
    
}

extension Identifier : IDecoderAlias where Raw : IDecoderAlias {
    
    public typealias KeychainDecoder = Coder.Identifier< Raw.KeychainDecoder, Kind >
    
}

extension Identifier : IEncoderAlias where Raw : IEncoderAlias {
    
    public typealias KeychainEncoder = Coder.Identifier< Raw.KeychainEncoder, Kind >
    
}
