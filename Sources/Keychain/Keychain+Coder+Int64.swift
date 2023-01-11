//
//  KindKit
//

import Foundation

public extension Keychain.Coder {

    struct Int64 : IKeychainValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.Int64 {
            let string = try Keychain.Coder.String.decode(value)
            guard let number = Swift.Int64(string) else {
                throw Keychain.Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.Int64) throws -> Data {
            return try Keychain.Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension Int64 : IKeychainCoderAlias {
    
    public typealias KeychainDecoder = Keychain.Coder.Int64
    public typealias KeychainEncoder = Keychain.Coder.Int64
    
}
