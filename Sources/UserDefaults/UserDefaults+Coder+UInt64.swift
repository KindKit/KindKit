//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct UInt64 : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Swift.UInt64 {
            return try UserDefaults.Coder.NSNumber.decode(value).uint64Value
        }
        
        public static func encode(_ value: Swift.UInt64) throws -> IUserDefaultsValue {
            return try UserDefaults.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension UInt64 : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.UInt64
    public typealias UserDefaultsEncoder = UserDefaults.Coder.UInt64
    
}
