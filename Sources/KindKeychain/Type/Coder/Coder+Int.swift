//
//  KindKit
//

import Foundation

public extension Coder {

    struct Int : IValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.Int {
            let string = try Coder.String.decode(value)
            guard let number = Swift.Int(string) else {
                throw Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.Int) throws -> Data {
            return try Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension Int : ICoderAlias {
    
    public typealias KeychainDecoder = Coder.Int
    public typealias KeychainEncoder = Coder.Int
    
}
