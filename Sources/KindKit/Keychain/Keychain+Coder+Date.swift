//
//  KindKit
//

import Foundation

public extension Keychain.Coder {

    struct Date : IKeychainValueCoder {
        
        public static func decode(_ value: Data) throws -> Foundation.Date {
            return Foundation.Date(timeIntervalSince1970: try Keychain.Coder.Double.decode(value))
        }
        
        public static func encode(_ value: Foundation.Date) throws -> Data {
            return try Keychain.Coder.Double.encode(Swift.Double(value.timeIntervalSince1970))
        }
        
    }
    
}

extension Date : IKeychainCoderAlias {
    
    public typealias KeychainDecoder = Keychain.Coder.Date
    public typealias KeychainEncoder = Keychain.Coder.Date
    
}
