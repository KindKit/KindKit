//
//  KindKit
//

import Foundation

public extension Coder {

    struct Bool : IValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.Bool {
            guard let byte = value.first else {
                throw Error.cast
            }
            return byte == 1
        }
        
        public static func encode(_ value: Swift.Bool) throws -> Data {
            switch value {
            case false: return Data([0])
            case true: return Data([1])
            }
        }
        
    }
    
}

extension Bool : ICoderAlias {
    
    public typealias KeychainDecoder = Coder.Bool
    public typealias KeychainEncoder = Coder.Bool
    
}
