//
//  KindKit
//

import Foundation

public extension Keychain.Coder {

    struct Int : IKeychainValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.Int {
            let string = try Keychain.Coder.String.decode(value)
            guard let number = Swift.Int(string) else {
                throw Keychain.Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.Int) throws -> Data {
            return try Keychain.Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension Int : IKeychainCoderAlias {
    
    public typealias KeychainDecoder = Keychain.Coder.Int
    public typealias KeychainEncoder = Keychain.Coder.Int
    
}
