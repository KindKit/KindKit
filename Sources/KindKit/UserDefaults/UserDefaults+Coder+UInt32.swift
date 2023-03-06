//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct UInt32 : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Swift.UInt32 {
            return try UserDefaults.Coder.NSNumber.decode(value).uint32Value
        }
        
        public static func encode(_ value: Swift.UInt32) throws -> IUserDefaultsValue {
            return try UserDefaults.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension UInt32 : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.UInt32
    public typealias UserDefaultsEncoder = UserDefaults.Coder.UInt32
    
}
