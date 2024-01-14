//
//  KindKit
//

import Foundation

public extension Coder {

    struct Int16 : IValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.Int16 {
            let string = try Coder.String.decode(value)
            guard let number = Swift.Int16(string) else {
                throw Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.Int16) throws -> Data {
            return try Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension Int16 : ICoderAlias {
    
    public typealias KeychainDecoder = Coder.Int16
    public typealias KeychainEncoder = Coder.Int16
    
}
