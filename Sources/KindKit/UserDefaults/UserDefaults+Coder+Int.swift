//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct Int : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Swift.Int {
            return try UserDefaults.Coder.NSNumber.decode(value).intValue
        }
        
        public static func encode(_ value: Swift.Int) throws -> IUserDefaultsValue {
            return try UserDefaults.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Int : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.Int
    public typealias UserDefaultsEncoder = UserDefaults.Coder.Int
    
}
