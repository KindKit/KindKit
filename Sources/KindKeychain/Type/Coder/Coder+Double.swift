//
//  KindKit
//

import Foundation

public extension Coder {

    struct Double : IValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.Double {
            let string = try Coder.String.decode(value)
            guard let number = Swift.Double(string) else {
                throw Error.cast
            }
            return number
        }
        
        public static func encode(_ value: Swift.Double) throws -> Data {
            return try Coder.String.encode(Swift.String(value))
        }
        
    }
    
}

extension Double : ICoderAlias {
    
    public typealias KeychainDecoder = Coder.Double
    public typealias KeychainEncoder = Coder.Double
    
}
