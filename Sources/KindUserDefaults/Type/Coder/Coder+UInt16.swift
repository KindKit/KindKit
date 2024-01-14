//
//  KindKit
//

import Foundation

public extension Coder {

    struct UInt16 : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Swift.UInt16 {
            return try Coder.NSNumber.decode(value).uint16Value
        }
        
        public static func encode(_ value: Swift.UInt16) throws -> IValue {
            return try Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension UInt16 : ICoderAlias {
    
    public typealias UserDefaultsDecoder = Coder.UInt16
    public typealias UserDefaultsEncoder = Coder.UInt16
    
}
