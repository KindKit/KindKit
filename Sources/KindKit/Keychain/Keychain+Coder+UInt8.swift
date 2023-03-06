//
//  KindKit
//

import Foundation

public extension Keychain.Coder {

    struct UInt8 : IKeychainValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.UInt8 {
            let string = try Keychain.Coder.String.decode(value)
            guard let number = Swift.UInt8(string) else {
                throw Keychain.Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.UInt8) throws -> Data {
            return try Keychain.Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension UInt8 : IKeychainCoderAlias {
    
    public typealias KeychainDecoder = Keychain.Coder.UInt8
    public typealias KeychainEncoder = Keychain.Coder.UInt8
    
}
