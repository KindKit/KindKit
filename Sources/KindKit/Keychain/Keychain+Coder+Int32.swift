//
//  KindKit
//

import Foundation

public extension Keychain.Coder {

    struct Int32 : IKeychainValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.Int32 {
            let string = try Keychain.Coder.String.decode(value)
            guard let number = Swift.Int32(string) else {
                throw Keychain.Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.Int32) throws -> Data {
            return try Keychain.Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension Int32 : IKeychainCoderAlias {
    
    public typealias KeychainDecoder = Keychain.Coder.Int32
    public typealias KeychainEncoder = Keychain.Coder.Int32
    
}
