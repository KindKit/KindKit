//
//  KindKit
//

import Foundation

public extension Coder {

    struct Float : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Swift.Float {
            return try Coder.NSNumber.decode(value).floatValue
        }
        
        public static func encode(_ value: Swift.Float) throws -> IValue {
            return try Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Float : ICoderAlias {
    
    public typealias UserDefaultsDecoder = Coder.Float
    public typealias UserDefaultsEncoder = Coder.Float
    
}
