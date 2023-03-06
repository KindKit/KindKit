//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct UInt8 : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Swift.UInt8 {
            return try UserDefaults.Coder.NSNumber.decode(value).uint8Value
        }
        
        public static func encode(_ value: Swift.UInt8) throws -> IUserDefaultsValue {
            return try UserDefaults.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension UInt8 : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.UInt8
    public typealias UserDefaultsEncoder = UserDefaults.Coder.UInt8
    
}
