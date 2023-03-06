//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct Int16 : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Swift.Int16 {
            return try UserDefaults.Coder.NSNumber.decode(value).int16Value
        }
        
        public static func encode(_ value: Swift.Int16) throws -> IUserDefaultsValue {
            return try UserDefaults.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Int16 : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.Int16
    public typealias UserDefaultsEncoder = UserDefaults.Coder.Int16
    
}
