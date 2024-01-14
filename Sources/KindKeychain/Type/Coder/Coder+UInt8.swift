//
//  KindKit
//

import Foundation

public extension Coder {

    struct UInt8 : IValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.UInt8 {
            let string = try Coder.String.decode(value)
            guard let number = Swift.UInt8(string) else {
                throw Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.UInt8) throws -> Data {
            return try Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension UInt8 : ICoderAlias {
    
    public typealias KeychainDecoder = Coder.UInt8
    public typealias KeychainEncoder = Coder.UInt8
    
}
