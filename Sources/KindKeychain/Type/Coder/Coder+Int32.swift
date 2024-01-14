//
//  KindKit
//

import Foundation

public extension Coder {

    struct Int32 : IValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.Int32 {
            let string = try Coder.String.decode(value)
            guard let number = Swift.Int32(string) else {
                throw Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.Int32) throws -> Data {
            return try Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension Int32 : ICoderAlias {
    
    public typealias KeychainDecoder = Coder.Int32
    public typealias KeychainEncoder = Coder.Int32
    
}
