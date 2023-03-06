//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct UInt : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Swift.UInt {
            return try UserDefaults.Coder.NSNumber.decode(value).uintValue
        }
        
        public static func encode(_ value: Swift.UInt) throws -> IUserDefaultsValue {
            return try UserDefaults.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension UInt : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.UInt
    public typealias UserDefaultsEncoder = UserDefaults.Coder.UInt
    
}
