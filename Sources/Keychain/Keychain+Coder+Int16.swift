//
//  KindKit
//

import Foundation

public extension Keychain.Coder {

    struct Int16 : IKeychainValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.Int16 {
            let string = try Keychain.Coder.String.decode(value)
            guard let number = Swift.Int16(string) else {
                throw Keychain.Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.Int16) throws -> Data {
            return try Keychain.Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension Int16 : IKeychainCoderAlias {
    
    public typealias KeychainDecoder = Keychain.Coder.Int16
    public typealias KeychainEncoder = Keychain.Coder.Int16
    
}
