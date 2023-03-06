//
//  KindKit
//

import Foundation

public extension Keychain.Coder {

    struct Double : IKeychainValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.Double {
            let string = try Keychain.Coder.String.decode(value)
            guard let number = Swift.Double(string) else {
                throw Keychain.Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.Double) throws -> Data {
            return try Keychain.Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension Double : IKeychainCoderAlias {
    
    public typealias KeychainDecoder = Keychain.Coder.Double
    public typealias KeychainEncoder = Keychain.Coder.Double
    
}
