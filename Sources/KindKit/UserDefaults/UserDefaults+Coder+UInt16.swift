//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct UInt16 : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Swift.UInt16 {
            return try UserDefaults.Coder.NSNumber.decode(value).uint16Value
        }
        
        public static func encode(_ value: Swift.UInt16) throws -> IUserDefaultsValue {
            return try UserDefaults.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension UInt16 : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.UInt16
    public typealias UserDefaultsEncoder = UserDefaults.Coder.UInt16
    
}
