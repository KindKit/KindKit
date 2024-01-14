//
//  KindKit
//

import Foundation

public extension Coder {

    struct Int : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Swift.Int {
            return try Coder.NSNumber.decode(value).intValue
        }
        
        public static func encode(_ value: Swift.Int) throws -> IValue {
            return try Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Int : ICoderAlias {
    
    public typealias UserDefaultsDecoder = Coder.Int
    public typealias UserDefaultsEncoder = Coder.Int
    
}
