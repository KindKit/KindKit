//
//  KindKit
//

import Foundation

public extension Coder {

    struct URL : IValueCoder {
        
        public static func decode(_ value: Data) throws -> Foundation.URL {
            let string = try Coder.String.decode(value)
            guard let url = Foundation.URL(string: string) else {
                throw Error.cast
            }
            return url
        }
        
        public static func encode(_ value: Foundation.URL) throws -> Data {
            guard let data = value.absoluteString.data(using: .utf8) else {
                throw Error.cast
            }
            return data
        }
        
    }
    
}

extension URL : ICoderAlias {
    
    public typealias KeychainDecoder = Coder.URL
    public typealias KeychainEncoder = Coder.URL
    
}
