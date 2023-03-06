//
//  KindKit
//

import Foundation

public extension Keychain.Coder {

    struct UInt32 : IKeychainValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.UInt32 {
            let string = try Keychain.Coder.String.decode(value)
            guard let number = Swift.UInt32(string) else {
                throw Keychain.Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.UInt32) throws -> Data {
            return try Keychain.Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension UInt32 : IKeychainCoderAlias {
    
    public typealias KeychainDecoder = Keychain.Coder.UInt32
    public typealias KeychainEncoder = Keychain.Coder.UInt32
    
}
