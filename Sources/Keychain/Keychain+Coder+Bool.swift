//
//  KindKit
//

import Foundation

public extension Keychain.Coder {

    struct Bool : IKeychainValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.Bool {
            guard let byte = value.first else {
                throw Keychain.Error.cast
            }
            return byte == 1
        }
        
        public static func encode(_ value: Swift.Bool) throws -> Data {
            switch value {
            case false: return Data([0])
            case true: return Data([1])
            }
        }
        
    }
    
}

extension Bool : IKeychainCoderAlias {
    
    public typealias KeychainDecoder = Keychain.Coder.Bool
    public typealias KeychainEncoder = Keychain.Coder.Bool
    
}
