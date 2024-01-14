//
//  KindKit
//

import Foundation

public extension Coder {

    struct String : IValueCoder {
        
        public static func decode(_ value: Data) throws -> Swift.String {
            guard let string = Swift.String(data: value, encoding: .utf8) else {
                throw Error.cast
            }
            return string
        }
        
        public static func encode(_ value: Swift.String) throws -> Data {
            guard let data = value.data(using: .utf8) else {
                throw Error.cast
            }
            return data
        }
        
    }
    
    struct NonEmptyString : IValueDecoder {
        
        public static func decode(_ value: Data) throws -> Swift.String {
            let string = try Coder.String.decode(value)
            if string.isEmpty == true {
                throw Error.cast
            }
            return string
        }
        
    }
    
}

extension String : ICoderAlias {
    
    public typealias KeychainDecoder = Coder.String
    public typealias KeychainEncoder = Coder.String
    
}
