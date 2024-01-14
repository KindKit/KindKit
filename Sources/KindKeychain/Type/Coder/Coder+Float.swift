//
//  KindKit
//

import Foundation

public extension Coder {

    struct Float : IValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.Float {
            let string = try Coder.String.decode(value)
            guard let number = Swift.Float(string) else {
                throw Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.Float) throws -> Data {
            return try Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension Float : ICoderAlias {
    
    public typealias KeychainDecoder = Coder.Float
    public typealias KeychainEncoder = Coder.Float
    
}
