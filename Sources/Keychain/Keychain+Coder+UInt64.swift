//
//  KindKit
//

import Foundation

public extension Keychain.Coder {

    struct UInt64 : IKeychainValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.UInt64 {
            let string = try Keychain.Coder.String.decode(value)
            guard let number = Swift.UInt64(string) else {
                throw Keychain.Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.UInt64) throws -> Data {
            return try Keychain.Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension UInt64 : IKeychainCoderAlias {
    
    public typealias KeychainDecoder = Keychain.Coder.UInt64
    public typealias KeychainEncoder = Keychain.Coder.UInt64
    
}
