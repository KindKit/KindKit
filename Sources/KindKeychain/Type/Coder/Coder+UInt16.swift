//
//  KindKit
//

import Foundation

public extension Coder {

    struct UInt16 : IValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.UInt16 {
            let string = try Coder.String.decode(value)
            guard let number = Swift.UInt16(string) else {
                throw Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.UInt16) throws -> Data {
            return try Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension UInt16 : ICoderAlias {
    
    public typealias KeychainDecoder = Coder.UInt16
    public typealias KeychainEncoder = Coder.UInt16
    
}
