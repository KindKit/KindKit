//
//  KindKit
//

import Foundation

public extension Coder {

    struct UInt64 : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Swift.UInt64 {
            return try Coder.NSNumber.decode(value).uint64Value
        }
        
        public static func encode(_ value: Swift.UInt64) throws -> IValue {
            return try Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension UInt64 : ICoderAlias {
    
    public typealias UserDefaultsDecoder = Coder.UInt64
    public typealias UserDefaultsEncoder = Coder.UInt64
    
}
