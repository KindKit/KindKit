//
//  KindKit
//

import Foundation

public extension Coder {

    struct UInt8 : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Swift.UInt8 {
            return try Coder.NSNumber.decode(value).uint8Value
        }
        
        public static func encode(_ value: Swift.UInt8) throws -> IValue {
            return try Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension UInt8 : ICoderAlias {
    
    public typealias UserDefaultsDecoder = Coder.UInt8
    public typealias UserDefaultsEncoder = Coder.UInt8
    
}
