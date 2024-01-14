//
//  KindKit
//

import Foundation

public extension Coder {

    struct Int8 : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Swift.Int8 {
            return try Coder.NSNumber.decode(value).int8Value
        }
        
        public static func encode(_ value: Swift.Int8) throws -> IValue {
            return try Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Int8 : ICoderAlias {
    
    public typealias UserDefaultsDecoder = Coder.Int8
    public typealias UserDefaultsEncoder = Coder.Int8
    
}
