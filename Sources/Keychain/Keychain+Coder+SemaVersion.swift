//
//  KindKit
//

import Foundation

public extension Keychain.Coder {

    struct SemaVersion : IKeychainValueDecoder {
        
        public static func decode(_ value: Data) throws -> KindKit.SemaVersion {
            let string = try Keychain.Coder.String.decode(value)
            guard let version = KindKit.SemaVersion(string) else {
                throw Keychain.Error.cast
            }
            return version
        }
        
    }
    
}

extension SemaVersion : IKeychainDecoderAlias {
    
    public typealias KeychainDecoder = Keychain.Coder.SemaVersion
    
}
