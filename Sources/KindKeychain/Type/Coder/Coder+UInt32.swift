//
//  KindKit
//

import Foundation

public extension Coder {

    struct UInt32 : IValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.UInt32 {
            let string = try Coder.String.decode(value)
            guard let number = Swift.UInt32(string) else {
                throw Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.UInt32) throws -> Data {
            return try Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension UInt32 : ICoderAlias {
    
    public typealias KeychainDecoder = Coder.UInt32
    public typealias KeychainEncoder = Coder.UInt32
    
}
