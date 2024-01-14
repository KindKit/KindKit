//
//  KindKit
//

import Foundation

public extension Coder {

    struct Int32 : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Swift.Int32 {
            return try Coder.NSNumber.decode(value).int32Value
        }
        
        public static func encode(_ value: Swift.Int32) throws -> IValue {
            return try Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Int32 : ICoderAlias {
    
    public typealias UserDefaultsDecoder = Coder.Int32
    public typealias UserDefaultsEncoder = Coder.Int32
    
}
