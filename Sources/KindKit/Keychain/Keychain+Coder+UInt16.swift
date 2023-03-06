//
//  KindKit
//

import Foundation

public extension Keychain.Coder {

    struct UInt16 : IKeychainValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.UInt16 {
            let string = try Keychain.Coder.String.decode(value)
            guard let number = Swift.UInt16(string) else {
                throw Keychain.Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.UInt16) throws -> Data {
            return try Keychain.Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension UInt16 : IKeychainCoderAlias {
    
    public typealias KeychainDecoder = Keychain.Coder.UInt16
    public typealias KeychainEncoder = Keychain.Coder.UInt16
    
}
