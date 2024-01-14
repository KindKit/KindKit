//
//  KindKit
//

import Foundation

public extension Coder {

    struct UInt32 : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Swift.UInt32 {
            return try Coder.NSNumber.decode(value).uint32Value
        }
        
        public static func encode(_ value: Swift.UInt32) throws -> IValue {
            return try Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension UInt32 : ICoderAlias {
    
    public typealias UserDefaultsDecoder = Coder.UInt32
    public typealias UserDefaultsEncoder = Coder.UInt32
    
}
