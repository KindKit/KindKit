//
//  KindKit
//

import Foundation

public extension Coder {

    struct Int64 : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Swift.Int64 {
            return try Coder.NSNumber.decode(value).int64Value
        }
        
        public static func encode(_ value: Swift.Int64) throws -> IValue {
            return try Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Int64 : ICoderAlias {
    
    public typealias UserDefaultsDecoder = Coder.Int64
    public typealias UserDefaultsEncoder = Coder.Int64
    
}
