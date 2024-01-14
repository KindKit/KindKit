//
//  KindKit
//

import Foundation

public extension Coder {

    struct Int64 : IValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.Int64 {
            let string = try Coder.String.decode(value)
            guard let number = Swift.Int64(string) else {
                throw Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.Int64) throws -> Data {
            return try Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension Int64 : ICoderAlias {
    
    public typealias KeychainDecoder = Coder.Int64
    public typealias KeychainEncoder = Coder.Int64
    
}
