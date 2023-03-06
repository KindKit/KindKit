//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct Date : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Foundation.Date {
            let number = try UserDefaults.Coder.NSNumber.decode(value)
            return Foundation.Date(timeIntervalSince1970: number.doubleValue)
        }
        
        public static func encode(_ value: Foundation.Date) throws -> IUserDefaultsValue {
            return try UserDefaults.Coder.NSNumber.encode(Foundation.NSNumber(value: Swift.Int(value.timeIntervalSince1970)))
        }
        
    }
    
}

extension Date : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.Date
    public typealias UserDefaultsEncoder = UserDefaults.Coder.Date
    
}
