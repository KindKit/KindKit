//
//  KindKit
//

import Foundation

public extension Keychain.Coder {

    struct Float : IKeychainValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.Float {
            let string = try Keychain.Coder.String.decode(value)
            guard let number = Swift.Float(string) else {
                throw Keychain.Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.Float) throws -> Data {
            return try Keychain.Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension Float : IKeychainCoderAlias {
    
    public typealias KeychainDecoder = Keychain.Coder.Float
    public typealias KeychainEncoder = Keychain.Coder.Float
    
}
