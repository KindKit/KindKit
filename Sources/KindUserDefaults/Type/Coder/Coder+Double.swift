//
//  KindKit
//

import Foundation

public extension Coder {

    struct Double : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Swift.Double {
            return try Coder.NSNumber.decode(value).doubleValue
        }
        
        public static func encode(_ value: Swift.Double) throws -> IValue {
            return try Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Double : ICoderAlias {
    
    public typealias UserDefaultsDecoder = Coder.Double
    public typealias UserDefaultsEncoder = Coder.Double
    
}
