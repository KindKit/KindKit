//
//  KindKit
//

import Foundation

public extension Keychain.Coder {

    struct Int8 : IKeychainValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.Int8 {
            let string = try Keychain.Coder.String.decode(value)
            guard let number = Swift.Int8(string) else {
                throw Keychain.Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.Int8) throws -> Data {
            return try Keychain.Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension Int8 : IKeychainCoderAlias {
    
    public typealias KeychainDecoder = Keychain.Coder.Int8
    public typealias KeychainEncoder = Keychain.Coder.Int8
    
}
