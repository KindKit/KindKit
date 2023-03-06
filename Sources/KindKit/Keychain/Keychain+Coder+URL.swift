//
//  KindKit
//

import Foundation

public extension Keychain.Coder {

    struct URL : IKeychainValueCoder {
        
        public static func decode(_ value: Data) throws -> Foundation.URL {
            let string = try Keychain.Coder.String.decode(value)
            guard let url = Foundation.URL(string: string) else {
                throw Keychain.Error.cast
            }
            return url
        }
        
        public static func encode(_ value: Foundation.URL) throws -> Data {
            guard let data = value.absoluteString.data(using: .utf8) else {
                throw Keychain.Error.cast
            }
            return data
        }
        
    }
    
}

extension URL : IKeychainCoderAlias {
    
    public typealias KeychainDecoder = Keychain.Coder.URL
    public typealias KeychainEncoder = Keychain.Coder.URL
    
}
