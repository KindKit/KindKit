//
//  KindKit
//

import Foundation

public extension Coder {

    struct UInt64 : IValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.UInt64 {
            let string = try Coder.String.decode(value)
            guard let number = Swift.UInt64(string) else {
                throw Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.UInt64) throws -> Data {
            return try Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension UInt64 : ICoderAlias {
    
    public typealias KeychainDecoder = Coder.UInt64
    public typealias KeychainEncoder = Coder.UInt64
    
}
