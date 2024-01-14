//
//  KindKit
//

import Foundation

public extension Coder {

    struct UInt : IValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.UInt {
            let string = try Coder.String.decode(value)
            guard let number = Swift.UInt(string) else {
                throw Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.UInt) throws -> Data {
            return try Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension UInt : ICoderAlias {
    
    public typealias KeychainDecoder = Coder.UInt
    public typealias KeychainEncoder = Coder.UInt
    
}
