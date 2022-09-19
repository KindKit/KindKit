//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct Double : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Swift.Double {
            return try UserDefaults.Coder.NSNumber.decode(value).doubleValue
        }
        
        public static func encode(_ value: Swift.Double) throws -> IUserDefaultsValue {
            return try UserDefaults.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Double : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.Double
    public typealias UserDefaultsEncoder = UserDefaults.Coder.Double
    
}
