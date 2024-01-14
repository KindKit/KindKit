//
//  KindKit
//

import Foundation

public extension Coder {

    struct UInt : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Swift.UInt {
            return try Coder.NSNumber.decode(value).uintValue
        }
        
        public static func encode(_ value: Swift.UInt) throws -> IValue {
            return try Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension UInt : ICoderAlias {
    
    public typealias UserDefaultsDecoder = Coder.UInt
    public typealias UserDefaultsEncoder = Coder.UInt
    
}
