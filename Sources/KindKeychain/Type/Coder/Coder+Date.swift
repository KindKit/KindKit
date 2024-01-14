//
//  KindKit
//

import Foundation

public extension Coder {

    struct Date : IValueCoder {
        
        public static func decode(_ value: Data) throws -> Foundation.Date {
            return Foundation.Date(timeIntervalSince1970: try Coder.Double.decode(value))
        }
        
        public static func encode(_ value: Foundation.Date) throws -> Data {
            return try Coder.Double.encode(Swift.Double(value.timeIntervalSince1970))
        }
        
    }
    
}

extension Date : ICoderAlias {
    
    public typealias KeychainDecoder = Coder.Date
    public typealias KeychainEncoder = Coder.Date
    
}
