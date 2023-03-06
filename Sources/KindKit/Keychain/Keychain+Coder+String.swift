//
//  KindKit
//

import Foundation

public extension Keychain.Coder {

    struct String : IKeychainValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.String {
            guard let string = Swift.String(data: value, encoding: .utf8) else {
                throw Keychain.Error.cast
            }
            return string
        }
        
        public static func encode(_ value: Swift.String) throws -> Data {
            guard let data = value.data(using: .utf8) else {
                throw Keychain.Error.cast
            }
            return data
        }
        
    }
    
    struct NonEmptyString : IKeychainValueDecoder {
        
        public static func decode(_ value: Data) throws -> Swift.String {
            let string = try Keychain.Coder.String.decode(value)
            if string.isEmpty == true {
                throw Keychain.Error.cast
            }
            return string
        }
        
    }
    
}

extension String : IKeychainCoderAlias {
    
    public typealias KeychainDecoder = Keychain.Coder.String
    public typealias KeychainEncoder = Keychain.Coder.String
    
}
