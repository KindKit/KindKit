//
//  KindKit
//

import Foundation

public extension Coder {

    struct Int8 : IValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.Int8 {
            let string = try Coder.String.decode(value)
            guard let number = Swift.Int8(string) else {
                throw Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.Int8) throws -> Data {
            return try Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension Int8 : ICoderAlias {
    
    public typealias KeychainDecoder = Coder.Int8
    public typealias KeychainEncoder = Coder.Int8
    
}
