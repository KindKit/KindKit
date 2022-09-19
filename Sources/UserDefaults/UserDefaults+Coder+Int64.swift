//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct Int64 : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Swift.Int64 {
            return try UserDefaults.Coder.NSNumber.decode(value).int64Value
        }
        
        public static func encode(_ value: Swift.Int64) throws -> IUserDefaultsValue {
            return try UserDefaults.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Int64 : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.Int64
    public typealias UserDefaultsEncoder = UserDefaults.Coder.Int64
    
}
