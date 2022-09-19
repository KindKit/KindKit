//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct Decimal : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Foundation.Decimal {
            return try UserDefaults.Coder.NSDecimalNumber.decode(value) as Foundation.Decimal
        }
        
        public static func encode(_ value: Foundation.Decimal) throws -> IUserDefaultsValue {
            return try UserDefaults.Coder.NSDecimalNumber.encode(Foundation.NSDecimalNumber(decimal: value))
        }
        
    }
    
}

extension Decimal : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.Decimal
    public typealias UserDefaultsEncoder = UserDefaults.Coder.Decimal
    
}
