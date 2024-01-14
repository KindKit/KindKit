//
//  KindKit
//

import Foundation

public extension Coder {

    struct Int16 : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Swift.Int16 {
            return try Coder.NSNumber.decode(value).int16Value
        }
        
        public static func encode(_ value: Swift.Int16) throws -> IValue {
            return try Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Int16 : ICoderAlias {
    
    public typealias UserDefaultsDecoder = Coder.Int16
    public typealias UserDefaultsEncoder = Coder.Int16
    
}
