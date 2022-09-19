//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct Int32 : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Swift.Int32 {
            return try UserDefaults.Coder.NSNumber.decode(value).int32Value
        }
        
        public static func encode(_ value: Swift.Int32) throws -> IUserDefaultsValue {
            return try UserDefaults.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Int32 : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.Int32
    public typealias UserDefaultsEncoder = UserDefaults.Coder.Int32
    
}
