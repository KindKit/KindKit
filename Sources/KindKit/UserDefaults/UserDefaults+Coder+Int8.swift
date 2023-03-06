//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct Int8 : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Swift.Int8 {
            return try UserDefaults.Coder.NSNumber.decode(value).int8Value
        }
        
        public static func encode(_ value: Swift.Int8) throws -> IUserDefaultsValue {
            return try UserDefaults.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Int8 : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.Int8
    public typealias UserDefaultsEncoder = UserDefaults.Coder.Int8
    
}
