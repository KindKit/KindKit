//
//  KindKit
//

import Foundation

public extension Keychain.Coder {

    struct UInt : IKeychainValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.UInt {
            let string = try Keychain.Coder.String.decode(value)
            guard let number = Swift.UInt(string) else {
                throw Keychain.Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.UInt) throws -> Data {
            return try Keychain.Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension UInt : IKeychainCoderAlias {
    
    public typealias KeychainDecoder = Keychain.Coder.UInt
    public typealias KeychainEncoder = Keychain.Coder.UInt
    
}
