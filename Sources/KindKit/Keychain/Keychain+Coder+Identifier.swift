//
//  KindKit
//

import Foundation

public extension Keychain.Coder {
    
    struct Identifier< Coder, Kind : IIdentifierKind > {
    }
    
}

extension Keychain.Coder.Identifier : IKeychainValueDecoder where Coder : IKeychainValueDecoder {
    
    public static func decode(_ value: Data) throws -> KindKit.Identifier< Coder.KeychainDecoded, Kind > {
        return Identifier(try Coder.decode(value))
    }
    
}

extension Keychain.Coder.Identifier : IKeychainValueEncoder where Coder : IKeychainValueEncoder {
    
    public static func encode(_ value: KindKit.Identifier< Coder.KeychainEncoded, Kind >) throws -> Data {
        return try Coder.encode(value.raw)
    }
    
}

extension Identifier : IKeychainDecoderAlias where Raw : IKeychainDecoderAlias {
    
    public typealias KeychainDecoder = Keychain.Coder.Identifier< Raw.KeychainDecoder, Kind >
    
}

extension Identifier : IKeychainEncoderAlias where Raw : IKeychainEncoderAlias {
    
    public typealias KeychainEncoder = Keychain.Coder.Identifier< Raw.KeychainEncoder, Kind >
    
}
