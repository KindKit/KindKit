//
//  KindKit
//

import Foundation

public extension Coder {

    struct Decimal : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Foundation.Decimal {
            return try Coder.NSDecimalNumber.decode(value) as Foundation.Decimal
        }
        
        public static func encode(_ value: Foundation.Decimal) throws -> IValue {
            return try Coder.NSDecimalNumber.encode(Foundation.NSDecimalNumber(decimal: value))
        }
        
    }
    
}

extension Decimal : ICoderAlias {
    
    public typealias UserDefaultsDecoder = Coder.Decimal
    public typealias UserDefaultsEncoder = Coder.Decimal
    
}
